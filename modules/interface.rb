# frozen_string_literal: true

class String
  def black
    "\e[30m#{self}\e[0m"
  end

  def red
    "\e[31m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def brown
    "\e[33m#{self}\e[0m"
  end

  def magenta
    "\e[35m#{self}\e[0m"
  end

  def cyan
    "\e[36m#{self}\e[0m"
  end

  def gray
    "\e[37m#{self}\e[0m"
  end

  def bg_brown
    "\e[43m#{self}\e[0m"
  end

  def bg_gray
    "\e[47m#{self}\e[0m"
  end
end

module Interface
  class << self
    def intro
      puts 'Добро пожаловать в игру Black Jack!'.green
      print 'Представьтесь: '

      name = gets.chomp.capitalize
    end

    def continue
      puts 'Продолжаем? (y/n)'

      answer = gets.chomp

      exit if answer == 'n'
    end

    def round(bet, bank)
      puts
      puts "Игроки сделали ставки по #{bet}$.".brown
      puts
      puts "Банк - #{bank}$".red
      puts
      puts 'Идет раздача карт..'.brown
      sleep(1)
    end

    def stand(player)
      puts "#{player.name} пропускает ход".brown
      sleep(1)
    end

    def hit(player)
      puts "#{player.name} взял карту".brown
      sleep(1)
    end

    def out(player)
      puts "#{player.name} раскрыл карты".brown
      sleep(1)
    end

    def turn
      sleep(1)
    end

    def action(hit_disable)
      puts 'Ваш ход!'.brown
      puts

      loop do
        puts "s [пропустить ход],#{hit_disable ? '' : ' h [взять карту],'} o [раскрыть карты], e [выйти]".green
        puts

        action = gets.chomp
        puts

        error = lambda do
          puts 'Неверно введена команда'.red
          puts
        end

        case action
          when 's'
            return :stand
          when 'h'
            hit_disable ? error.call : (return :hit)
          when 'o'
            return :out
          when 'e'
            exit
          else
            error.call
        end
      end
    end

    def auto_out
      puts 'Игроки набрали по 3 карты.'.cyan
      sleep(1)
    end

    def over_score
      puts 'Перебор!'.red
      sleep(1)
    end

    def zero_balance(player)
      puts "К сожалению, баланс #{player.name} равен нулю. Игра завершена.".red
      exit
    end

    def show_result(result, user, dealer)
      puts
      puts 'Завершаем раунд!'.magenta
      sleep(2)
      puts

      case result
        when 'loss'
          print 'Вы проиграли!'.red
        when 'win'
          print 'Вы выиграли!'.green
        when 'draw'
          print 'Ничья!'.gray
      end

      puts " Счет: #{user.score} : #{dealer.score}"
      puts
      puts 'Итоговые карты, счет и баланс игроков:'

      render(user, dealer, true)

      sleep(2)
    end

    def render(user, dealer, out = false)
      board_width = 50

      get_half_gap = lambda do |string, rest = false|
        gap = board_width - string.size
        inaccuracy = gap.even? ? '' : ' '

        ' ' * (gap / 2) + (rest ? '' : inaccuracy)
      end

      board_gap = ' ' * board_width

      dealer_info = "#{dealer.name}: ← #{out ? dealer.score : '??'} || #{dealer.balance}$"
      dealer_cards = dealer.cards.map { |card| out ? "[#{card.suit} #{card.rank}]" : '[XX]' }.join

      user_info = "#{user.name}: ← #{user.score} || #{user.balance}$"
      user_cards = user.cards.map { |card| "[#{card.suit} #{card.rank}]" }.join

      bg = out ? :bg_brown : :bg_gray

      puts
      puts board_gap.send(bg)
      puts "#{get_half_gap.call(dealer_info)}#{dealer_info}#{get_half_gap.call(dealer_info, true)}".black.send(bg)
      puts board_gap.send(bg)
      puts "#{get_half_gap.call(dealer_cards)}#{dealer_cards}#{get_half_gap.call(dealer_cards, true)}".black.send(bg)
      puts board_gap.send(bg)
      puts "#{get_half_gap.call(user_info)}#{user_info}#{get_half_gap.call(user_info, true)}".black.send(bg)
      puts board_gap.send(bg)
      puts "#{get_half_gap.call(user_cards)}#{user_cards}#{get_half_gap.call(user_cards, true)}".black.send(bg)
      puts board_gap.send(bg)
      puts
    end
  end
end
