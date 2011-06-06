require 'rake'
require 'rspec/core/rake_task'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :spec

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

desc 'Generate documentation for the instrumental plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Instrumental'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Default: run the specs"
task :default => [:spec]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "instrumental"
    s.summary = s.description = "Rails instrumentation and client for imperialapp.com"
    s.email = "support@imperialapp.com"
    s.homepage = "http://github.com/imperialapp/instrumental"
    s.authors = ["Douglas F Shearer"]
    s.files =  `git ls-files`.split("\n")
  end
end