require 'spec_helper'

describe Payload do
  before do
    @payload = test_data('initial_commit')
  end

  it "should respond to methods with instantiated keys and reject those without" do
    @payload.respond_to?(:user_name).should be_true
    @payload.respond_to?(:blah_name).should_not be_true
    @payload.respond_to?(:repository_project_account_name).should be_true
    @payload.respond_to?(:repository_project_account_fizzboff).should_not be_true
  end

  it "should return string values for leaf nodes" do
    @payload.repository_project_status.should == 'active'
  end

  it "should return hash for branches" do
    @payload.user.should == {
      'email' => 'joe.bloggs@example.com',
      'name' => 'Joe Bloggs',
      'username' => 'joe.bloggs'
    }
  end

  it "should raise no method for invalid entries" do
    lambda do
      @payload.user_foobar
    end.should raise_error NoMethodError
  end

  it "should return a number for the commit count" do
    @payload.commits_count.should == 1
  end

  it "should return the affected branch name" do
    @payload.branch_name.should == 'master'
  end
end
