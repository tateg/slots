require 'tty-spinner'

class SlotMachine
  attr_reader :spins, :purse

  def initialize
    @spin_config = { 
      format: :bouncing_ball,
      hide_cursor: true,
      interval: 12
    }
    @spinner = TTY::Spinner.new(@spin_config)
    @spins = 0
    @purse = 25
  end

  def spin
    puts "Welcome to slots! You currently have: #{@purse} credits"
    harvest_kidney if @purse.zero?
    prompt("Pull the lever and pay 1 credit?")
    @spins += 1
    @purse -= 1
    spinimation
    show_result(win?)
    spin
  end

  def spinimation
    @spinner.auto_spin
    sleep 5
    @spinner.stop
  end

  def show_result(cond)
    if cond
      creds = value(@spins)
      puts "You won! You have been awarded #{creds} credits!"
      @purse += creds
    else
      puts "Loser! Try again..."
    end
  end

  private

  def harvest_kidney
    puts "You ran out of credits and can no longer afford to play!"
    prompt("Would you like to harvest a kidney and sell it for more credits?")
    puts "Looking for a buyer..."
    spinimation
    price = rand(20)
    puts "You sold your kidney for #{price} credits!"
    @purse += price
  end

  def value(spins)
    case spins
    when 100..1000
      100
    when 75..99
      75
    when 50..74
      50
    when 25..49
      30
    when 11..24
      20
    when 1..10
      10
    end
  end

  def prompt(msg)
    print "#{msg} (y/n): "
    res = gets.chomp
    exit if res.downcase == "n"
  end

  def win?
    rand(50) == rand(50)
  end
end

sl = SlotMachine.new
sl.spin
