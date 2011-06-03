namespace :instrumental do

  desc 'Installs the configuration initializer'
  task :install do
    unless ENV.include?('api_key')
      raise "usage: rake instrumental:install api_key=YOUR_API_KEY"
    end

    api_key = ENV['api_key']
    template_path = File.expand_path(File.join(File.dirname(__FILE__), 'templates', 'instrumental.rb.erb'))
    template = ERB.new(File.read(template_path))
    location = File.join('config', 'initializers', 'instrumental.rb')

    File.open(location, 'w+') do |f|
      f.write template.result(binding)
    end

    puts 'Instrumental Installed!'
    puts "Configuration written to #{location}"

  end

end