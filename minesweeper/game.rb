module Minesweeper
  ##
  # This class is the main interface between the game lib and the world. It can
  # receive data from outside the lib and pass the board state as a result,
  # along other functionalities
  class Game
    ##
    # The initialize start the game.
    def initialize(type: :custom, width: nil, height: nil, mines: nil)
      @board = if type == :custom
                 Board.new(width: width, height: height, mines: mines)
               else
                 Board.new(Board::SIZES[type])
               end
    end

    def board_state
      @board.grid || @board.board_nil
    end
  end
end
