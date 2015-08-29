Tilt.register Tilt::ERBTemplate, 'html.erb'

get '/' do
    @page_class = 'home'
  erb :home
end

get '/about' do
    @page_class = 'about'
  erb :about
end

get '/works' do
    @page_class = 'works'
  erb :works
end