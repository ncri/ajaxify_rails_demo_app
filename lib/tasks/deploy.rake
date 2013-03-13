
namespace :deploy do

  task :clear_cache_after => :environment do
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

if Rake::Task.task_defined?("assets:precompile:nondigest")
  Rake::Task["assets:precompile:nondigest"].enhance do
  	client = ::Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
  	AjaxifyTest::Application.load_tasks
  	client.post_ps 'ajaxify-demo', 'rake deploy:clear_cache_after'
  	puts 'Started rake deploy:clear_cache_after in new process'
  end
end