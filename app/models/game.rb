class Game < ApplicationRecord

  attr_reader :player_deck, :bot_deck, :id

  def self.find id
    YAML.load(Redis.current.get("game:#{id}"))
  end

  def initialize
    @id = SecureRandom.uuid
    deck = Deck.new
    Deck.shuffle(deck)

    @player_deck, @bot_deck = deck.deal(2)

    Redis.current.set("game:#{id}", self.to_yaml)
  end

  def turn cards_for_winner = [], result = {}

    result[:player_cards] ||= []
    result[:bot_cards]    ||= []
    result[:wars]         ||= 0

    player_card           = @player_deck.shift
    bot_card              = @bot_deck.shift

    result[:player_cards] << player_card
    result[:bot_cards]    << bot_card
    cards_for_winner      += [player_card, bot_card]

    if player_card.value > bot_card.value
      @player_deck += cards_for_winner
      result[:winner] = "player"
    elsif bot_card.value > player_card.value
      @bot_deck += cards_for_winner
      result[:winner] = "bot"
    else
      result[:wars] += 1
      cards_to_risk = [@player_deck.length-1, @bot_deck.length-1, 3].min
      turn(cards_for_winner + @player_deck.shift(cards_to_risk) + @bot_deck.shift(cards_to_risk), result)
    end

    result[:game_over] = over?

    Redis.current.set("game:#{id}", self.to_yaml)
    result
  end

  def status
    { player: player_deck.length, bot: bot_deck.length }
  end

  def over?
    player_deck.length == 0 || bot_deck.length == 0
  end
end
