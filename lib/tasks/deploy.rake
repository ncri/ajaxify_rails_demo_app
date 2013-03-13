if Rake::Task.task_defined?("assets:precompile:nondigest")

	namespace :deploy do

	  task :blubi, [:old_release] => :environment do |t, args|
	  	puts blab
	  end

	  def blab
	  	'Yööööö'
	  end

	end

  Rake::Task["assets:precompile"].enhance do
  	client = ::Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
  	old_release = client.get_releases(ENV['APP_NAME']).body.last['name'].sub('v','')
  	client.post_ps ENV['APP_NAME'], "rake deploy:blubi[#{old_release}]"
  	puts 'Started rake deploy:clear_cache_after_new_release_startup in new process'
  end
end