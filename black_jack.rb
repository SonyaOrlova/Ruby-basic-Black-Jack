# frozen_string_literal: true

require_relative './models/player'
require_relative './models/card_deck'

require_relative './modules/interface'

class BlackJack
  BLACK_JACK = 21

  MIN_CARDS_COUNT = 2
  MAX_CARDS_COUNT = 3

  BALANCE = 100
  BET = 10

  def initialize
    user_name = Interface.intro
    dealer_name = 'Дилер'

    @user = Player.new(user_name, BALANCE)
    @dealer = Player.new(dealer_name, BALANCE)

    round
  end

  def continue
    @user.balance.zero? && Interface.zero_balance(@user)
    @dealer.balance.zero? && Interface.zero_balance(@dealer)

    Interface.continue

    @user.reset
    @dealer.reset

    round
  end

  def round
    @card_deck = CardDeck.new

    @bank = @user.bet(BET) + @dealer.bet(BET)

    Interface.round(BET, @bank)

    MIN_CARDS_COUNT.times do
      pick_card(@user)
      pick_card(@dealer)
    end

    Interface.render(@user, @dealer)

    @active_player = @user

    check
  end

  def stand
    Interface.stand(@active_player)

    turn

    check
  end

  def hit
    Interface.hit(@active_player)

    pick_card(@active_player)

    Interface.render(@user, @dealer)

    turn

    check
  end

  def out
    Interface.out(@active_player)

    show_result
  end

  def turn
    Interface.turn

    case @active_player
      when @user
        @active_player = @dealer
      when @dealer
        @active_player = @user
    end
  end

  def check
    auto_out = @user.cards.size == MAX_CARDS_COUNT && @dealer.cards.size == MAX_CARDS_COUNT
    over_score = @user.score > BLACK_JACK || @dealer.score > BLACK_JACK

    if auto_out || over_score
      auto_out && Interface.auto_out
      over_score && Interface.over_score

      show_result
    else
      move
    end
  end

  def move
    hit_disable = @active_player.cards.size == MAX_CARDS_COUNT

    case @active_player
      when @user
        action = Interface.action(hit_disable)
        send(action)
      when @dealer
        @dealer.score >= 17 || hit_disable ? stand : hit
    end
  end

  def show_result
    result = 'draw'
    result = 'win' if @dealer.score > BLACK_JACK || (@user.score <= BLACK_JACK && @user.score > @dealer.score)
    result = 'loss' if @user.score > BLACK_JACK || (@dealer.score <= BLACK_JACK && @dealer.score > @user.score)

    case result
      when 'loss'
        @dealer.win(@bank)
      when 'win'
        @user.win(@bank)
      when 'draw'
        half = @bank / 2

        @user.win(half)
        @dealer.win(half)
    end

    Interface.show_result(result, @user, @dealer)

    continue
  end

  def pick_card(player)
    card = @card_deck.pick_card

    case card.rank
      when 'A'
        value = player.score <= BLACK_JACK - 11 ? 11 : 1
      when 'J', 'Q', 'K'
        value = 10
      else
        value = card.rank.to_i
    end

    player.take_card(card, value)
  end
end
