class Deck < ApplicationRecord

  attr_reader :cards

  SUITS = [ :diamonds, :clubs, :hearts, :spades ]
  CARDS = [ { value: 2,  display: "2"  },
            { value: 3,  display: "3"  },
            { value: 4,  display: "4"  },
            { value: 5,  display: "5"  },
            { value: 6,  display: "6"  },
            { value: 7,  display: "7"  },
            { value: 8,  display: "8"  },
            { value: 9,  display: "9"  },
            { value: 10, display: "10" },
            { value: 11, display: "J"  },
            { value: 12, display: "Q"  },
            { value: 13, display: "K"  },
            { value: 14, display: "A"  }
          ]

  def self.shuffle deck
    deck.shuffle!
  end

  def initialize
    @cards = []

    SUITS.each do |suit|
      CARDS.each do |card|
        @cards << Card.new( { suit: suit, value: card[:value], display: card[:display] } )
      end
    end
  end

  def shuffle!
    cards.shuffle!
  end

  def deal players
    player_decks = cards.each_slice(cards.length/players).to_a

    if player_decks.length > players
      leftovers = player_decks.pop
      leftovers.each_with_index { |c,i| player_decks[i] << c }
    end

    player_decks
  end
end
