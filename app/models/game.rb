class Game < ApplicationRecord

  attr_reader :player_deck, :bot_deck, :id

  def self.find id
    new(JSON.parse(Redis.current.get("game:#{id}")))
  end

  def initialize data = {}
    @id = data["id"] || SecureRandom.uuid

    unless data.empty?
      @player_deck  = data["player_deck"].map { |c| Card.new(suit: c["suit"].to_sym, value: c["value"].to_i, display: c["display"]) }
      @bot_deck     = data["bot_deck"].map    { |c| Card.new(suit: c["suit"].to_sym, value: c["value"].to_i, display: c["display"]) }
    else
      deck = Deck.new
      Deck.shuffle(deck)
      @player_deck, @bot_deck = deck.deal(2)
      Redis.current.set("game:#{id}", self.to_json)
    end

  end

  def turn cards_for_winner = [], result = {}
    result = Result.new

    result.player_cards ||= []
    result.bot_cards    ||= []
    result.wars         ||= 0

    player_card           = @player_deck.shift
    bot_card              = @bot_deck.shift

    result.player_cards << player_card
    result.bot_cards    << bot_card
    cards_for_winner      += [player_card, bot_card]

    if player_card.value > bot_card.value
      @player_deck += cards_for_winner
      result.winner = "player"
      result.loser  = "bot"
    elsif bot_card.value > player_card.value
      @bot_deck += cards_for_winner
      result.winner = "bot"
      result.loser  = "player"
    else
      result.wars += 1
      cards_to_risk = [@player_deck.length-1, @bot_deck.length-1, 3].min
      turn(cards_for_winner + @player_deck.shift(cards_to_risk) + @bot_deck.shift(cards_to_risk), result)
    end

    result.game_over = over?

    Redis.current.set("game:#{id}", self.to_json)
    result
  end

  def status
    { player: player_deck.length, bot: bot_deck.length }
  end

  def over?
    player_deck.length == 0 || bot_deck.length == 0
  end
end
