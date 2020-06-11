# frozen_string_literal: true

class CardDeck
  SUITS = %w[♧ ♤ ♡ ♢].freeze
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  attr_reader :cards

  class Card
    attr_reader :suit, :rank

    def initialize(suit, rank)
      @suit = suit
      @rank = rank
    end
  end

  def initialize
    @cards = []

    SUITS.each { |suit| RANKS.each { |rank| @cards << Card.new(suit, rank) } }
    @cards.shuffle!
  end

  def pick_card
    @cards.shift
  end
end
