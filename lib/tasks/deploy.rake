# if Rake::Task.task_defined?("assets:precompile:nondigest")

# 	namespace :deploy do

# 	  task :blubi, [:old_release] => :environment do |t, args|
# 	  	puts blab
# 	  end

# 	  def blab
# 	  	'Yööööö'
# 	  end

# 	end

#   Rake::Task["assets:precompile"].enhance do
#   	client = ::Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
#   	old_release = client.get_releases(ENV['APP_NAME']).body.last['name'].sub('v','')
#   	client.post_ps ENV['APP_NAME'], "rake deploy:blubi[#{old_release}]"
#   	puts 'Started rake deploy:clear_cache_after_new_release_startup in new process'
#   end
# end


if Rake::Task.task_defined?("assets:precompile:nondigest")
  Rake::Task["assets:precompile:nondigest"].enhance do
  	client = ::Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
  	client.post_ps 'ajaxify-demo', 'rake deploy:clear_cache_after_new_release_startup'
  	puts 'Started rake deploy:clear_cache_after_new_release_startup in new process'
  end
end


namespace :deploy do

  task :clear_cache_after_new_release_startup => :environment do
  	client = ::Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
  	old_release_number = client.get_releases('ajaxify-demo').body.last['name'].sub('v','').to_i
  	puts "Running new release startup detection for cache clearing (old release is #{old_release_number})..."
  	while !new_release_up?(client, old_release_number) do 
  		sleep 10
  	end
		Rails.cache.clear
		puts 'Cache cleared after release startup.'
  end

  def new_release_up? client, old_release_number
  	running_releases = client.get_ps('ajaxify-demo').body.find_all{ |a| a['process'] =~ /web/ }.map{ |p| p['release'] }
  	if running_releases.uniq.length == 1 and running_releases.first == old_release_number
  		running_actions = client.get_ps('ajaxify-demo').body.find_all{ |a| a['process'] =~ /web/ }.map{ |p| p['action'] }
  		if running_actions.uniq.length == 1 and running_actions.first == 'up'
  			puts 'New release up!'
  			puts "Current release is #{running_releases.first}"
  			return true
  		end
  	end
  	puts "There are still instances running with the old release #{old_release_number}"
  	return false
  end

end