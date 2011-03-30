require 'spec_helper'

describe CodebaseParser do
  def messages_for(name)
    CodebaseParser.parse_notification(payload(name))
  end

  def commit_link_for(ref)
    "https://example.codebasehq.com/example/test/commit/#{ref}"
  end

  context 'with a single commit' do
    subject { messages_for 'initial_commit' }
    its(:count) { should == 1 }

    it 'should mention the project and branch' do
      subject.first.should be_start_with '[Test/master] '
    end

    it 'should return the commit message' do
      subject.first.should include 'Initial commit.'
    end

    it 'should cite the commit author' do
      subject.first.should include '- Joe Bloggs'
    end

    it 'should have a link to the commit' do
      subject.first.should include commit_link_for('744af2102c59736a919d66901fe143ebe8424cdb')
    end
  end
end
