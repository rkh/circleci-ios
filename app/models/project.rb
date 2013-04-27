class Project

  PROJ_ATTRS = %w[vcs_url followed branches branch_info]
  PROJ_ATTRS.each { |prop| attr_accessor prop }

  def initialize(attrs = {})
    attrs.each do |key, value|
      self.send("#{key.to_s}=", value) if PROJ_ATTRS.member? key
    end
  end

  def all_branches
    return [] unless branches
    branches.keys
  end

  def branch_name
    return '' unless branch_info
    "#{branch_info['name']}"
  end

  def repo_name
    vcs_url.to_s.gsub('https://github.com/', '')
  end

end
