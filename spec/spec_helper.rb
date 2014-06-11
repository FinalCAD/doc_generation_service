require 'rubygems'
require 'bundler/setup'

begin
  require 'pry'
rescue LoadError
end

require 'rack'
require 'rspec'
require 'rack/test'

require_relative '../app/app'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.before { }
  config.after  { }
end

def app
  PrinceXmlWrapper.new
end
