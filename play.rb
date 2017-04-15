#!/usr/bin/env ruby

require_relative 'minesweeper'

def start_game(*args)
  game = Minesweeper::Game.new(*args)
  printer = Minesweeper::SimplePrinter.new

  while game.still_playing?
    printer.print_board(game.board_state)

    print 'select the line to reveal: '
    line = Integer(gets)

    print 'select the column to reveal: '
    column = Integer(gets)

    game.click(column, line)
  end
rescue Interrupt
  puts "\n\nThanks for playing!"
end

# start_game(type: :custom, columns: 20, lines: 20, mines: 100)
start_game(type: :beginner)

# printer.print_board(game.board_state, x_ray: true)
