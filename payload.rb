class Payload
  def initialize data
    @data = data
  end

  def method_missing(method, *arguments, &block)
    get(method.to_s) || super
  end

  def respond_to?(method, include_private = false)
    super || !!get(method.to_s)
  end

  def commits_count_s
    commits_count == 1 ? "a commit" : "#{commits_count} commits"
  end

  def commits_count
    @commit_count ||= commits.size
  end

  def repository_branch
    %Q[#{repository_name}/#{branch_name}]
  end

  def branch_name
    ref[%r{^refs/heads/(.*)$}, 1]
  end

  private

  def get name
    name.split('_').inject(@data) { |item, key| item.respond_to?(:[]) && item[key] }
  end
end
