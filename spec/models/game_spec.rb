require "rails_helper"

RSpec.describe Game do
  context "initialize" do
    it "creates a new deck split in half" do
      game = FactoryGirl.build(:game)
      expect(game.player_deck.length).to eq(26)
      expect(game.bot_deck.length).to eq(26)
    end
  end

  context "turn" do
    it "adds awards a card to the winner from the loser" do
      game        = FactoryGirl.build( :game )
      player_card = FactoryGirl.build( :card, value: 2, display: "2" )
      bot_card    = FactoryGirl.build( :card, value: 3, display: "3" )
      game.instance_variable_set( :@player_deck,  [player_card] )
      game.instance_variable_set( :@bot_deck,     [bot_card]    )
      game.turn
      expect(game.player_deck.length).to eq(0)
      expect(game.bot_deck.length).to eq(2)
    end
  end
end
