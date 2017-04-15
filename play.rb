#!/usr/bin/env ruby

require_relative 'minesweeper'

game = Minesweeper::Game.new(type: :custom, width: 20, height: 20, mines: 100)
# game = Minesweeper::Game.new(type: :beginner)

p game.board_state
