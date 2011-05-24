require 'rake'
require 'rspec/core/rake_task'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

desc 'Generate documentation for the stats_collector plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'StatsCollector'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Default: run the specs"
task :default => [:spec]