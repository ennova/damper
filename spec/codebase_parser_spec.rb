require 'spec_helper'

describe CodebaseParser do
  def messages_for(name)
    CodebaseParser.parse_notification(payload(name))
  end

  def commit_link_for(ref)
    "https://example.codebasehq.com/example/test/#{ref.is_a?(Range) ? 'compare' : 'commit'}/#{ref}"
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

  context 'with multiple commits' do
    subject { messages_for 'multi_commit_added' }
    its(:count) { should == 3 } # 2 commits + 1 summary line

    it 'should mention the project and branch in each line' do
      subject.each { |line| line.should be_start_with '[Test/master] ' }
    end

    it 'should return the commit messages' do
      subject[0].should include 'Added bar'
      subject[1].should include 'Added baz'
    end

    it 'should cite the commit author' do
      subject[0].should include 'Joe Bloggs'
      subject[1].should include 'Joe Bloggs'
    end

    it 'should not link to individual commits' do
      subject[0].should_not match %r{https?://}
      subject[1].should_not match %r{https?://}
    end

    it 'should have a summary line' do
      subject.last.should include 'commits'
    end

    it 'should include short refspec range in the summary' do
      subject.last.should include '744af21...6dddaab'
    end

    it 'should have a link to the commit range in the summary' do
      subject.last.should include commit_link_for('744af2102c59736a919d66901fe143ebe8424cdb'..'6dddaab454dab22e1df5544940e577e3481dd666')
    end

  end

  context 'with a multiline commit message' do
    subject { messages_for 'multiline_message' }
    its(:count) { should == 1}

    it 'should terminate the first line with an ellipsis' do
      subject.first.should include 'Fix line endings. ...'
    end

    it 'should not include additional lines in the commit message' do
      subject.first.should_not include 'lorem ipsum'
    end

    it 'should not include any newlines in the output' do
      subject.first.should_not include "\n"
    end
  end
end
