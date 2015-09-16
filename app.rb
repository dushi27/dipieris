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
  ENV['GIT_TOKEN'] ||= '64262e2be8f80d5263dcf3716bdb2c6377b3a394'
  @page_class = 'works'
  base = 'https://api.github.com/'
  token = "?access_token=#{ENV['GIT_TOKEN']}"
  @number_commits = 0
  @weekly_commits = []
  @languages = {}
  repos = Unirest.get("#{base}user/repos#{token}")
  repos.body.each do |repo|
    language = repo['language'] ||= 'Other'
    if @languages.has_key? language 
      @languages[language] += 1 
    else
      @languages[language] = 1
    end
    stats = Unirest.get("#{base}repos/#{repo['owner']['login']}/#{repo['name']}/stats/participation#{token}")
    stats.body.each do |stat|
      @number_commits += stat.last[-4,4].inject{|sum,x| sum + x } unless stat.last[-4,4].nil? 
    end
  end
  @num_repos = @languages.values.inject { |sum, x| sum + x }
  erb :works
end

