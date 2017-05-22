$slack_config = YAML.load_file(File.join(Rails.root, "config", "slack.yml")).
                  each_with_object({}) { |(k,v), memo| memo[k.to_sym] = v }

Slack.configure do |config|
  config.token = $slack_config[:bot_use_oath_access_token]
end

$slack_client = Slack::Web::Client.new
