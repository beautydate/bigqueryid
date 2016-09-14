Gem::Specification.new do |gem|
  gem.name        = 'bigqueryid'
  gem.version     = '0.1.0'
  gem.date        = '2016-09-12'
  gem.summary     = "Google BigQuery ORM"
  gem.description = "Simple ORM to Google BigQuery"
  gem.authors     = ["Fabio Tomio"]
  gem.email       = 'fabiotomio@gmail.com'
  gem.homepage    = 'http://github.com/fabiotomio/bigqueryid'
  gem.license     = 'MIT'

  gem.files        = Dir["README.md", "lib/**/*"]
  gem.require_path = "lib"

  gem.required_ruby_version = ">= 2.3.0"

  gem.add_dependency 'google-cloud-bigquery', '~> 0.20'
  gem.add_dependency 'activesupport', '~> 4.2'
  gem.add_dependency 'activemodel', '~> 4.2'
end