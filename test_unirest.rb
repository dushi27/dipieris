require 'unirest'
=begin
response = Unirest.get('https://api.github.com/users/dushi27/events/public?access_token=86a9ffa4df56622c77b309807ec3c2409cc9344e')
i = 0
response.body.each do |r|
    #puts "#{i} #{r['type']}"
    i+=1
=end


base = 'https://api.github.com/'
token = "?access_token=ENV['GIT_TOKEN']"
commits_by_repos = []
weekly_commits = []

repos = Unirest.get("#{base}user/repos#{token}")

repos.body.each do |repo|
  stats = Unirest.get("#{base}repos/#{repo['owner']['login']}/#{repo['name']}/stats/participation#{token}")
  stats.body.each do |stat|
    commit_count = stat.last[-4,4].to_a 
    commit_count = [0,0,0,0] if commit_count.count < 4 
    commits_by_repos << ['This Week', commit_count]
  end
end

commits_by_repos.transpose.each do |repo|
  weekly_commits << repo.inject{|sum,x| sum + x }
end
