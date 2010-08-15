require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "jcheck_rails"
    gem.summary = %Q{Generate jCheck code according to ActiveModel validations}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "wilkerlucio@gmail.com"
    gem.homepage = "http://github.com/wilkerlucio/jcheck_rails"
    gem.authors = ["Wilker Lucio"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "jcheck_rails #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
