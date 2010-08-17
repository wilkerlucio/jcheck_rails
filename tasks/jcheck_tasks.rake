require 'fileutils'
require 'open-uri'
require 'zip'

namespace :jcheck do
  desc "Download latest version of jcheck"
  task :setup => :environment do
    puts "Downloading jCheck..."
    
    tmp_dir = File.join(Rails.root, "tmp")
    
    FileUtils.mkdir_p(tmp_dir)
    
    tmp_path = File.join(tmp_dir, "jcheck.zip")
    
    File.open(tmp_path, "wb") { |f| f << open("http://jcheck.net/download/latest").read }
    
    public_path = File.join(Rails.root, "public")
    
    version = '0.0.0'
    
    Zip::ZipFile.open(tmp_path) do |zip|
      zip.each do |entry|
        next unless entry.file?
        
        version = $1 if entry.name =~ /jcheck-(\d+\.\d+\.\d+)/
        
        puts "Extracting #{entry.name}..."
        entry.extract(File.join(public_path, entry.name)) {true}
      end
    end
    
    puts
    puts "------------------------------------------------------------"
    puts "Now you need to configure your views, use following snippet:"
    puts
    puts "<%= stylesheet_link_tag 'jcheck' %>"
    puts "<%= javascript_include_tag 'jcheck-#{version}.min' %>"
    puts
    puts "And you also need to include the jQuery 1.4.2+ into your\nviews in order to jCheck works."
    puts "------------------------------------------------------------"
    
    File.delete(tmp_path)
  end
end