$giphy_config = YAML.load_file(File.join(Rails.root, "config", "giphy.yml")).
                  each_with_object({}) { |(k,v), memo| memo[k.to_sym] = v }


$giphy_client = GiphyClient.new
