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

    context "with valid credentials" do
      before do
        authorize 'alibaba', 'opensesame'
      end

      context "with mock room" do
        before do
          campfire = mock 'campfire'
          Tinder::Campfire.should_receive(:new).once.and_return(campfire)
          @room = mock 'room'
          campfire.should_receive(:find_room_by_name).once.and_return(@room)
        end

        it 'should speak once for single commit' do
          @room.should_receive(:speak).once
          post '/', :payload => payload_data('initial_commit')
          last_response.status.should == 200
        end

        it 'should speak three times for two commits' do
          @room.should_receive(:speak).exactly(3).times
          post '/', :payload => payload_data('multi_commit_modified')
          last_response.status.should == 200
        end
      end
    end
  end
end
