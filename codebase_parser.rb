require 'payload'

class CodebaseParser
  @limit = 5

  def self.parse_notification(payload)
    return [] if payload.repository_sync?
    messages = payload.commits.first(@limit).map do |commit|
      message = "[#{payload.repository_branch}] #{commit.message.sub(/[\r\n].*$/m, ' ...')} - #{commit.author_name}"
      message << " (#{commit.url})" if payload.commits_count == 1
      message
    end
    if payload.commits_count > 1
      message = "[#{payload.repository_branch}]"
      if payload.commits_count > @limit
        message << " (+#{payload.commits_count - @limit} more)"
      end
      message << " commits #{payload.before[0..6]}...#{payload.after[0..6]}: #{payload.url}"
      messages << message
    end
    messages
  end
end
