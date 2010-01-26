# This is the right place to load libraries & gems required to run the main app

require "uri"

begin
  require 'json'
rescue LoadError
  $stderr.puts "Missing gem. Please run 'gem install json'."
  exit 1
end

begin
  require 'twitter'
rescue LoadError
  $stderr.puts "Missing gem. Please run 'gem install twitter'."
  exit 1
end

begin
  require 'twitter/json_stream'
  rescue LoadError
    $stderr.puts "Missing gem. Please run 'gem install twitter-stream'."
  exit 1
end


begin
  require 'tmail'
rescue LoadError
  $stderr.puts "Missing gem. Please run 'gem install tmail'."
  exit 1
end

begin
  require 'httparty'
rescue LoadError
  $stderr.puts "Missing gem. Please run 'gem install httparty'."
  exit 1
end
