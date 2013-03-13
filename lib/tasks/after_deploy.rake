# testing...
if Rake::Task.task_defined?("assets:precompile:nondigest")
  Rake::Task["assets:precompile:nondigest"].enhance do
  	puts 'non_digest: '
  	c = ::Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
    puts c.get_ps('yousty-eu').body.find_all{ |a| a['process'] =~ /web/ }.map(&:release).inspect
    puts c.get_ps('yousty-eu').body.find_all{ |a| a['process'] =~ /web/ }.map(&:action).inspect
  end
else
  Rake::Task["assets:precompile"].enhance do
    puts 'digest: '
  	c = ::Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
    puts c.get_ps('yousty-eu').body.find_all{ |a| a['process'] =~ /web/ }.map(&:release).inspect
    puts c.get_ps('yousty-eu').body.find_all{ |a| a['process'] =~ /web/ }.map(&:action).inspect
  end
end