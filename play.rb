#!/usr/bin/env ruby

require_relative 'minesweeper'

# game = Minesweeper::Game.new(type: :custom,
#                              columns: 20,
#                              lines: 20,
#                              mines: 100)
game = Minesweeper::Game.new(type: :beginner)

Minesweeper::SimplePrinter.new.print_board(game.board_state)

game.click(4, 4)

Minesweeper::SimplePrinter.new.print_board(game.board_state, x_ray: true)
