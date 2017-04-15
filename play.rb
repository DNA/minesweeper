#!/usr/bin/env ruby

require_relative 'minesweeper'

def action_prompt
  print 'Select your action: 1: click / 2: flag (default: 1): '
  action = gets.chomp
  case action
  when '2', 'flag'
    :flag
  else
    :click
  end
end

def game_round(game, printer)
  printer.print_board(game.board_state)

  action = action_prompt

  print 'select a line: '
  line = Integer(gets)

  print 'select a column: '
  column = Integer(gets)

  game.send(action, column, line)
end

def start_game(*args)
  game = Minesweeper::Game.new(*args)
  printer = Minesweeper::SimplePrinter.new

  game_round(game, printer) while game.still_playing?
rescue Interrupt
  puts "\n\nThanks for playing!"
end

# start_game(type: :custom, columns: 20, lines: 20, mines: 100)
start_game(type: :beginner)
