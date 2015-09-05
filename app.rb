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
  #response = Unirest.get('https://api.github.com/user/repos?access_token=ENV['TOKEN'])
  base = 'https://api.github.com/'
  token = "?access_token=#{ENV['TOKEN']}"
  commits_by_repos = []
  @weekly_commits = []
  repos = Unirest.get("#{base}user/repos#{token}")
  @languages = {}
  repos.body.each do |r|
      langs = r['language'] ||= 'Other'
      if @languages.has_key? langs 
          @languages[langs].to_i += 1
      else
          @languages[langs]  = 1
      end
  end
  @page_class = 'works'
  @num_repos = @languages.values.inject { |a, b| a + b }
  

  
  repos = Unirest.get("#{base}user/repos#{token}")
  
  repos.body.each do |repo|
    stats = Unirest.get("#{base}repos/#{repo['owner']['login']}/#{repo['name']}/stats/participation#{token}")
    stats.body.each do |stat|
      commit_count = stat.last[-4,4].to_a 
      commit_count = [0,0,0,0] if commit_count.count < 4 
      commits_by_repos << commit_count
    end
  end
  
  commits_by_repos.transpose.each do |repo|
    @weekly_commits << repo.inject{|sum,x| sum + x }
  end
  
  @commits = {"#{Date.today}" => @weekly_commits.last, 
   (Date.today - 7).strftime('%d/%m/%Y') => @weekly_commits[3], 
   (Date.today - 21).strftime('%d/%m/%Y') => @weekly_commits[2],
   (Date.today - 28).strftime('%d/%m/%Y') => @weekly_commits[2],  
  }
  @number_commits = @weekly_commits.inject{|sum,x| sum + x }
  erb :works
end

