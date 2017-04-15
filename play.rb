#!/usr/bin/env ruby

require_relative 'minesweeper'

# game = Minesweeper::Game.new(type: :custom,
#                              columns: 20,
#                              lines: 20,
#                              mines: 100)
game = Minesweeper::Game.new(type: :beginner)

p game.board_state
