Capture::App.controllers :api do

	get "/capture" do
		url = params[:url]
		rs = ''
		return rs unless url =~ /^(http|https):\/\//
		if url_capture = UrlCapture.find_one({:url => url})
			rs = url_capture[:image_data]
		else
			Capture::Make.perform_async({:url => url, :format => "PNG", :width => 1280, :height => 1080})
		end
		rs
	end

end