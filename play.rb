#!/usr/bin/env ruby

require_relative 'minesweeper'

def line
  print 'select a line: '
  Integer(gets)
rescue ArgumentError
  puts 'Invalid value, try again'
  line
end

def column
  print 'select a column: '
  Integer(gets)
rescue ArgumentError
  puts 'Invalid value, try again'
  column
end

def action
  print 'Select your action: 1: click / 2: flag / 3: chord (default: 1): '
  action = gets.chomp
  case action
  when '3', 'chord'
    :chord
  when '2', 'flag'
    :flag
  else
    :click
  end
end

def game_round(game, printer)
  printer.print_board(game.board_state)

  game.send(action, line, column)
end

def game_end(game)
  if game.victory?
    puts 'Congratulations, you beat the board!'
  else
    puts 'Ouch, a mine! Good luck nest time :('
  end
end

def start_game(*args)
  game = Minesweeper::Game.new(*args)
  printer = Minesweeper::SimplePrinter.new

  game_round(game, printer) while game.still_playing?

  game_end(game)

  printer.print_board(game.board_state, x_ray: true)
rescue Interrupt
  puts "\n\nThanks for playing!"
end

# start_game(type: :custom, columns: 20, lines: 20, mines: 100)
start_game(type: :beginner)
