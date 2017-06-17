class GiphyClient

  def initialize
    @http_client = Faraday.new("#{$giphy_config[:url]}/#{$giphy_config[:api_version]}/gifs/")
  end

  def translate term
    response = get("translate", { "s" => term })
    response["data"]["images"]["downsized"]["url"]
  end

  private

  def get(action, params = {})
    response = @http_client.get do |request|
      request.url action
      request.params.merge!(params.merge({ "api_key" => $giphy_config[:api_key] }))
    end
    JSON.parse(response.body)
  rescue JSON::ParserError
    false
  end
end
