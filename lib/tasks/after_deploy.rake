# testing...
if Rake::Task.task_defined?("assets:precompile:nondigest")
  Rake::Task["assets:precompile:nondigest"].enhance do
  	client = ::Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
  	client.post_ps 'ajaxify-demo', 'rake deploy:clear_cache_after_new_release_startup'
  	puts 'Cache clearing after release startup started...'
  end
# else
#   Rake::Task["assets:precompile"].enhance do
#     puts 'digest: '
#   	c = ::Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
#     puts c.get_ps('ajaxify-demo').body.find_all{ |a| a['process'] =~ /web/ }.map{ |p| p['release'] }.inspect
#     puts c.get_ps('ajaxify-demo').body.find_all{ |a| a['process'] =~ /web/ }.map{ |p| p['action'] }.inspect
#   end
end


namespace :deploy do

  task :clear_cache_after_new_release_startup => :environment do
  	client = ::Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
  	old_release_number = client.get_releases('ajaxify-demo').body.last['name'].sub('v','').to_i
  	puts ''
  	puts "Running new release startup detection for cache clearing (old release is #{old_release_number})..."
  	puts ''
  	while !new_release_up?(client, old_release_number) do 
  		sleep 10
  	end
		Rails.cache.clear
		puts ''
		puts 'Cache cleared after release startup.'
		puts ''
  end


  def new_release_up? client, old_release_number
  	running_releases = client.get_ps('ajaxify-demo').body.find_all{ |a| a['process'] =~ /web/ }.map{ |p| p['release'] }
  	if running_releases.uniq.length == 1 and running_releases.first > old_release_number
  		running_actions = client.get_ps('ajaxify-demo').body.find_all{ |a| a['process'] =~ /web/ }.map{ |p| p['action'] }
  		if running_actions.uniq.length == 1 and running_actions.first == 'up'
  			puts ''
  			puts 'New release up!'
  			puts "Current release is #{running_releases.first}"
  			puts ''
  			return true
  		end
  	end
  	puts ''
  	puts "There are still instances running with the old release #{old_release_number}"
  	puts ''
  	return false
  end

end