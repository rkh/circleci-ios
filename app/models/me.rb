class Me

  ME_ATTRS = %w[login selected_email tokens]
  ME_ATTRS.each { |prop| attr_accessor prop }

  def initialize(attrs = {})
    attrs.each do |key, value|
      self.send("#{key.to_s}=", value) if ME_ATTRS.member? key
    end
  end

  def token
    tok = tokens.to_a.first
    return nil unless tok.is_a?(Hash)
    tok['token']
  end

end
