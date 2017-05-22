class ActionParser

  def self.act_on text, channel
    return if text.nil?

    channel_state = Redis.current.get("state:#{channel}")
    channel_game  = Redis.current.get("game:#{channel}")

    if channel_state.nil? && text =~ /play|game|start/
      $slack_client.chat_postMessage(channel: channel, text: "Would you like to play a game of War with me?")
      Redis.current.set("state:#{channel}", "request_to_start_game")
    elsif channel_state == "request_to_start_game" && text.strip =~ /^y/
      $slack_client.chat_postMessage(channel: channel, text: "Ok, let's do it!")
      game = Game.new
      Redis.current.set("game:#{channel}", game.id)
      $slack_client.chat_postMessage(channel: channel, text: $giphy_client.translate("war battle"))
      $slack_client.chat_postMessage(channel: channel, text: game.turn.to_s)
      $slack_client.chat_postMessage(channel: channel, text: "Next battle?")
      Redis.current.set("state:#{channel}", "request_for_next_turn")
    elsif channel_state == "request_for_next_turn" && text.strip =~ /^y/
      $slack_client.chat_postMessage(channel: channel, text: $giphy_client.translate("war battle"))
      result = Game.find(channel_game).turn

      if result[:game_over]
        $slack_client.chat_postMessage(channel: channel, text: "GAME OVER! #{result[:winner]} won!")
        $slack_client.chat_postMessage(channel: channel, text: "Wanna play again?")
        Redis.current.set("state:#{channel}", "request_to_start_game")
      else
        $slack_client.chat_postMessage(channel: channel, text: result.to_s)
        $slack_client.chat_postMessage(channel: channel, text: "Next battle?")
        Redis.current.set("state:#{channel}", "request_for_next_turn")
      end
    else
      $slack_client.chat_postMessage(channel: channel, text: "Do what now?")
    end
  end
end
