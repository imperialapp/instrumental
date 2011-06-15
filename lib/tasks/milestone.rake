namespace :instrumental do

  desc "Adds a milestone marker to the Imperial project"
  task :milestone => :environment do
    puts "Setting milestone..."
    response = Instrumental.milestone(ENV['name'])

    if response.is_a?(Net::HTTPSuccess)
      puts "Success!!"
    else
      puts "[Instrumental] Unexpected response from server (#{ response.code }): #{ response.message }"
    end
  end

end