require 'payload'

class CodebaseParser
  def self.parse_notification(payload)
    [ %Q[#{payload.user_name} pushed #{payload.commits_count_s} to #{payload.repository_branch}.] ]
  end

  # %Q[#{user.name} pushed #{commits.count} commits to #{repository.name} ]
end
