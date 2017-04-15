module Minesweeper
  ##
  # This class is the main interface between the game lib and the world. It can
  # receive data from outside the lib and pass the board state as a result,
  # along other functionalities
  class Game
    ##
    # The initialize start the game.
    def initialize(type: :custom, columns: nil, lines: nil, mines: nil)
      @board = if type == :custom
                 Board.new(columns: columns, lines: lines, mines: mines)
               else
                 Board.new(Board::SIZES[type])
               end
      @state = :new
      @victory = false
    end

    def board_state
      @board.grid || @board.board_nil
    end

    def click(column, line)
      if @state == :new
        @board.populate(column, line)
        @state = :started
      end

      return if @board.revealed?(column, line)

      cell = @board.reveal(column, line)

      @state == :over if cell[:type] == :bomb

    end

    def still_playing?
      @state != :over
    end
  end
end
