module Capture
  SCRIPT = File.expand_path('../../coffee/capture.coffee', __FILE__)

  class Make
    include Sidekiq::Worker
    sidekiq_options :queue => 'make_capture', :retry => false

    def perform(params)
      url, width, height = params["url"], params["width"], params["height"]
      format = params["format"].to_s.empty? ? 'PNG' : params["format"].upcase
      unless UrlCapture.find_one({:url => url})
        cmd = "/home/src/nodejs/phantomjs-1.9.7-linux-x86_64/bin/phantomjs #{Capture::SCRIPT} #{url.inspect} #{format} #{width} #{height}"
        json = MultiJson.load(%x[#{cmd}])
        capture = UrlCapture.new(
        		:url => url,
        		:image_data => json["imageData"]
        	)
        capture.save
      end
    end
  end

end