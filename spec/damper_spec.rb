require 'spec_helper'

describe Damper do
  include Rack::Test::Methods

  def app
    Damper
  end

  it 'should load index' do
    get '/'
    last_response.status.should == 200
    last_response.body.should =~ /meets Campfire/
    last_response.body.should_not =~ /meets CodebaseHQ/
  end
end
