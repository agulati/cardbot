class Result < ApplicationRecord

  attr_accessor :player_cards, :bot_cards, :wars, :winner, :game_over, :loser

  def to_s
    display = []

    if winner == "bot"
      display << "Ha ha! Victory is mine!"
    else
      display << "Drat! Foiled again!"
    end

    display << "We had #{wars} #{"war".pluralize(wars)}." if wars > 0

    display << "*#{send("#{winner}_cards".to_sym).last.to_s}* beats #{send("#{loser}_cards".to_sym).last.to_s}"

    display.join("\n")
  end
end
