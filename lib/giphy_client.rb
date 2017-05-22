class GiphyClient

  def initialize
    @http_client = Faraday.new("#{$giphy_config[:url]}/#{$giphy_config[:api_version]}/gifs/")
  end

  def translate term
    response = get("translate", { "s" => term })
    if response["data"] && response["data"]["images"]["downsized"]
      # response["data"]["images"]["fixed_height"]["url"]
      response["data"]["embed_url"]
    else
      false
    end
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
