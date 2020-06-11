# frozen_string_literal: true

class Player
  attr_reader :name, :balance, :cards, :score

  def initialize(name, balance)
    @name = name
    @balance = balance

    @cards = []
    @score = 0
  end

  def bet(bet)
    @balance -= bet

    bet
  end

  def take_card(card, value)
    @cards << card

    @score += value
  end

  def win(bank)
    @balance += bank
  end

  def reset
    @cards = []
    @score = 0
  end
end
