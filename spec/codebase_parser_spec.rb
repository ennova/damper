require 'spec_helper'

describe CodebaseParser do
  describe 'when handling a single commit payload' do
    before do
      @payload = test_data('initial_commit')
    end

    it 'should return one commit log' do
      messages = CodebaseParser.parse_notification(@payload)
      messages.first.should == "Joe Bloggs pushed a commit to Test/master."
    end
  end
end
