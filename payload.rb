class PayloadBase
  def initialize data
    @data = data
  end

  def method_missing(method, *arguments, &block)
    get(method) || super
  end

  def respond_to?(method, include_private = false)
    super || !!get(method)
  end

  def inspect
    @data.inspect
  end

  private

  def get name
    name.to_s.split('_').inject(@data) { |item, key| item.respond_to?(:[]) && item[key] }
  end
end

class Payload < PayloadBase
  def commits
    @commits ||= super.map { |data| PayloadBase.new(data) }
  end

  def commits_count
    commits.size
  end

  def commits_count_s
    commits_count == 1 ? "a commit" : "#{commits_count} commits"
  end

  def repository_branch
    %Q[#{repository_name}/#{branch_name}]
  end

  def branch_name
    ref[%r{^refs/heads/(.*)$}, 1]
  end
end
