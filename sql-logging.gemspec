require 'rubygems'
require 'rake'

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
  s.summary = 'Add SQL debugging info to ActiveRecord 3.x'
  s.description = 'Add SQL debugging info to ActiveRecord 3.x'
  s.files = FileList['lib/*'].to_a
  s.require_path = 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README']
  s.add_dependency('activerecord', '~> 3.0.0')
  s.add_dependency('actionpack', '~> 3.0.0')
end
