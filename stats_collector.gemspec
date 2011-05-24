Gem::Specification.new do |s|
  s.name = 'stats_collector'
  s.version = '0.1.1'
  s.homepage = 'http://stats.douglasfshearer.com'

  s.authors = 'Douglas F Shearer'
  s.email   = 'me@douglasfshearer.com'

  s.files = `git ls-files`.split("\n")

  s.summary = "Collect metrics on anything in your Rails or Rack app"
  s.description = s.summary
end
