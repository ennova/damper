$: << File.join(File.dirname(__FILE__), '..')

require 'environment'
require 'damper'
require 'rack/test'

set :environment, :test

def payload_data(name)
  filename = File.join(File.dirname(__FILE__), 'support', 'data', "#{name}.json")
  File.read filename
end

def payload(name)
  Payload.new JSON.parse(payload_data(name))
end
