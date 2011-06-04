Gem::Specification.new do |s|
  s.name = 'instrumental'
  s.version = '0.1.3'
  s.homepage = 'http://imperialapp.com'

  s.authors = 'Douglas F Shearer'
  s.email   = 'support@imperialapp.com'

  s.files = `git ls-files`.split("\n")

  s.summary = "Collect metrics on anything in your Rails or Rack app"
  s.description = s.summary
end
