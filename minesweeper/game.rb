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

      return if @board.revealed_or_flagged?(column, line)

      cell = @board.reveal(column, line)

      @state == :over if cell[:type] == :bomb

      spread(column, line) if cell[:type] == :blank
    end

    def flag(column, line)
      return if @state == :new

      @board.flag(column, line)
    end

    ##
    # When revealing a blank square, it's safe to revel everything around you,
    def spread(column, line)
      @board.neighbours(column, line).each do |cell|
        click(cell[:column], cell[:line])
      end
    end

    def still_playing?
      @state != :over
    end
  end
end
