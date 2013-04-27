class Build

  BUILD_ATTRS = %w[status branch subject user build_num]
  BUILD_ATTRS.each { |prop| attr_accessor prop }

  def initialize(attrs = {})
    attrs.each do |key, value|
      self.send("#{key.to_s}=", value) if BUILD_ATTRS.member? key
    end
  end

  def username
    user.nil? ? '' : user['name']
  end

  def status_color
    case status.to_s.downcase
    when 'error', 'failed', 'timedout' then '#903d3d'.to_color
    when 'started', 'running', 'queued' then '#84c0d7'.to_color
    when 'canceled', 'no_tests', 'broken' then '#e5e5e5'.to_color
    when 'passed', 'success', 'fixed' then '#6fb269'.to_color
    else
      '#d2ab59'.to_color
    end
  end

  def self.check_for_rewards(builds)
    return unless builds
    defaults = NSUserDefaults.standardUserDefaults
    info = defaults['user']
    rewards = defaults['rewards'] ? defaults['rewards'] : {}
    builds.each do |build|
      build.check_first_passing(info) unless rewards.fetch('first_passing', nil)
    end
  end

  def check_first_passing(info)
    if info['email'] == self.user['email']
      Kiip.sharedInstance.saveMoment('First passing build', withCompletionHandler: nil)
    end
  end

end
