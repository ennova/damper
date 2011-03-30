require 'payload'

class CodebaseParser
  def self.parse_notification(payload)
    payload.commits.map do |commit|
      "[#{payload.repository_branch}] #{commit.message} - #{commit.author_name} (#{commit.url})"
    end
  end
end
