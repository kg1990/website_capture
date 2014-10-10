page = require("webpage").create()
system = require("system")

userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17"
url = system.args[1]
format = (system.args[2] or "PNG").toUpperCase()
width = parseInt(system.args[3]) or 1280
height = parseInt(system.args[4]) or null # default: fit content
crop = true

setTimeout ->
  system.stderr.writeLine "Timing out..."
  phantom.exit 2
, 60000

render = ->
  result = page.evaluate ->
    result = {}

    result.title          = document.title if document?.title?

    if false # debug
      result.documentWidth  = document.width if document?.width?
      result.documentHeight = document.height if document?.height?
      result.innerWidth     = window.innerWidth if window?.innerWidth?
      result.innerHeight    = window.innerHeight if window?.innerHeight?
      result.clientWidth    = document.body.clientWidth if document?.body?.clientWidth?
      result.clientHeight   = document.body.clientHeight if document?.body?.clientHeight?

    result

  if crop and width > 0 and height > 0
    # Cropping isn't exactly what we want, but PhantomJS does
    # not yet have a "window size" concept (See NOTE above).
    page.clipRect =
      top: 0
      left: 0
      width: width
      height: height

    result.height = height
    result.width  = width

  delete result.height unless result.height
  delete result.width  unless result.width

  result.imageData = page.renderBase64(format)
  result.format = format

  console.log JSON.stringify(result)
  phantom.exit()

handleError = (type, msg, trace) ->
  msgStack = [type + "ERROR: " + msg]

  if trace
    msgStack.push "TRACE:"
    trace.forEach (t) ->
      msgStack.push " -> " + (t.file or t.sourceURL) + ": " + t.line + ((if t.function then " (in function " + t.function + ")" else ""))

  system.stderr.writeLine msgStack.join("\n")

page.settings.userAgent = userAgent

# NOTE: This does not work as "window" size, so height will
# not do as expected here.
#
# See https://github.com/ariya/phantomjs/issues/10619
page.viewportSize =
  width: width
  height: height

page.customHeaders = url: "https://grabshot.herokuapp.com"
page.onInitialized = ->
  # Make sure assets are fetched with the write Referer (else
  # TypeKit and possibly others don't work...).
  page.customHeaders.Referer = url

page.onError = (msg, trace) ->
  handleError "PAGE", msg, trace

phantom.onError = (msg, trace) ->
  handleError "PHANTOM", msg, trace
  phantom.exit 1

page.onLoadFinished = (status) ->
  loaded = page.evaluate -> !!document.body
  setTimeout render, 300  if status is "success" or loaded is true

page.open url