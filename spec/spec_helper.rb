$: << File.join(File.dirname(__FILE__), '..')

require 'environment'
require 'damper'
require 'rack/test'

set :environment, :test

def payload(name)
  filename = File.join(File.dirname(__FILE__), 'support', 'data', "#{name}.json")
  Payload.new(JSON.parse(File.read(filename)))
end
