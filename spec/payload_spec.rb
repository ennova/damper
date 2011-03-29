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
end
