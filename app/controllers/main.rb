Capture::App.controllers do

	get '/' do
		render '/main/test'
	end

	get 'list' do
		@url_captures = UrlCapture.all
		render '/main/list'
	end

	get 'clean' do
		UrlCapture.destroy_all
		redirect 'list'
	end
	
end