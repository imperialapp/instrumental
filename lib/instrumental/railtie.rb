require 'instrumental'
require 'rails'

module Instrumental
  class Railtie < Rails::Railtie
    railtie_name :instrumental

    rake_tasks do
      load "tasks/install.rake"
      load "tasks/milestone.rake"
    end
  end
end