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

  context "with auth config" do
    before do
      @old_auth = ENV['AUTH_USERNAME'], ENV['AUTH_PASSWORD']
      ENV['AUTH_USERNAME'], ENV['AUTH_PASSWORD'] = 'alibaba', 'opensesame'
    end

    after do
      ENV['AUTH_USERNAME'], ENV['AUTH_PASSWORD'] = @old_auth
    end

    it 'should reject anonymous posts' do
      post '/'
      last_response.status.should == 401
    end

    it 'should reject invalid password' do
      authorize 'alibaba', 'foobar'
      post '/'
      last_response.status.should == 401
    end

    it 'should accept valid credentials' do
      authorize 'alibaba', 'opensesame'
      post '/'
      last_response.status.should_not == 401
    end
  end
end
