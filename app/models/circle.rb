class Circle

  BASE_URI = 'https://circleci.com/api/v1'

  attr_accessor :token

  def initialize
    @token = nil
  end

  def self.shared_instance
    @shared ||= Circle.new
  end

  def default_headers
    { 'accept' => 'application/json', 'content-type' => 'application/json' }
  end

  def me(&block)
    url = "#{BASE_URI}/me?circle-token=#{@token}"
    BW::HTTP.get(url, { :headers => default_headers }) do |response|
      result_data = BW::JSON.parse(response.body.to_str)
      result_data = [] if result_data.empty?
      block.call Me.new(result_data)
    end
  end

  def recent_builds(&block)
    url = "#{BASE_URI}/recent-builds?circle-token=#{@token}"
    BW::HTTP.get(url, { :headers => default_headers }) do |response|
      result_data = BW::JSON.parse(response.body.to_str)
      result_data = [] if result_data.empty?
      print result_data
      block.call result_data.map { |attrs| Build.new attrs }
    end
  end

end
