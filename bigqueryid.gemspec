# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bigqueryid/version'

Gem::Specification.new do |spec|
  spec.name        = 'bigqueryid'
  spec.version     = Bigqueryid::VERSION
  spec.date        = '2016-11-24'
  spec.summary     = 'Google BigQuery ORM'
  spec.description = 'Simple ORM to Google BigQuery'
  spec.authors     = ['Fabio Tomio']
  spec.email       = 'fabiotomio@gmail.com'
  spec.homepage    = 'http://github.com/fabiotomio/bigqueryid'
  spec.license     = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'

  spec.add_dependency 'google-cloud-bigquery', '~> 0.20'
  spec.add_dependency 'activesupport', '~> 4.2'
  spec.add_dependency 'activemodel', '~> 4.2'
end
