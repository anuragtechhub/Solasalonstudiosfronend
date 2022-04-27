# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'pro/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'pro'
  s.version     = Pro::VERSION
  s.authors     = ['Serge White']
  s.email       = ['hard.sintex@gmail.com']
  s.homepage    = 'http://solaprofessional.com/'
  s.summary     = 'SolaProfessional API'
  s.description = 'SolaProfessional API'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 4.2.11.3'

  s.add_development_dependency 'sqlite3'
  s.metadata['rubygems_mfa_required'] = 'true'
end
