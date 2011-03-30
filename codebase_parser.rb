require 'payload'

class CodebaseParser
  def self.parse_notification(payload)
    messages = payload.commits.map do |commit|
      message = "[#{payload.repository_branch}] #{commit.message.sub(/[\r\n].*$/m, ' ...')} - #{commit.author_name}"
      message << " (#{commit.url})" if payload.commits_count == 1
      message
    end
    if payload.commits_count > 1
      messages << "[#{payload.repository_branch}] commits #{payload.before[0..6]}...#{payload.after[0..6]}: #{payload.url}"
    end
    messages
  end
end
