#!/usr/bin/env ruby

require_relative 'minesweeper'

def start_game(*args)
  game = Minesweeper::Game.new(*args)
  printer = Minesweeper::SimplePrinter.new

  while game.still_playing?
    printer.print_board(game.board_state)

    print 'Select your action: 1: click / 2: flag (default: 1): '
    action = gets.chomp
    case action
    when '2', 'flag'
      action_method = :flag
    else
      action_method = :click
    end

    print 'select a line: '
    line = Integer(gets)

    print 'select a column: '
    column = Integer(gets)

    game.send(action_method, column, line)
  end
rescue Interrupt
  puts "\n\nThanks for playing!"
end

# start_game(type: :custom, columns: 20, lines: 20, mines: 100)
start_game(type: :beginner)

# printer.print_board(game.board_state, x_ray: true)
