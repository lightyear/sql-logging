require 'rubygems'

lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'sql-logging/version'

Gem::Specification.new do |s| 
  s.name = 'sql-logging'
  s.version = SqlLogging::VERSION
  s.author = 'Steve Madsen'
  s.email = 'steve@lightyearsoftware.com'
  s.homepage = 'http://github.com/lightyear/sql-logging'
  s.platform = Gem::Platform::RUBY
  s.summary = 'SQL analysis and debugging info for Rails'
  s.description = 'Adds SQL analysis and debugging info to Rails applications.'
  s.files = Dir.glob('lib/**/*').to_a
  s.require_path = 'lib'
  s.extra_rdoc_files = ['README.rdoc']

  s.add_dependency('rails', '>= 4.0')

  s.add_development_dependency('rake')
  s.add_development_dependency('minitest', '>= 5.8.3')
end
