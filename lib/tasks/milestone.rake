namespace :instrumental do

  desc "Adds a milestone marker to the Imperial project"
  task :milestone => :environment do
    Instrumental.milestone(ENV['name'])
  end

end