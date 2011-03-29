$: << File.join(File.dirname(__FILE__), '..')

require 'environment'
require 'damper'
require 'rack/test'

set :environment, :test
