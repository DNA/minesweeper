module Minesweeper
  ##
  # This class is the main interface between the game lib and the world. It can
  # receive data from outside the lib and pass the board state as a result,
  # along other functionalities
  class Game
    ##
    # The initialize start the game.
    def initialize(type: :custom, lines: nil, columns: nil, mines: nil)
      @board = if type == :custom
                 Board.new(lines: lines, columns: columns, mines: mines)
               else
                 Board.new(Board::SIZES[type])
               end
      @state = :new
      @victory = false
    end

    def board_state
      @board.grid
    end

    def click(line, column)
      if @state == :new
        @board.populate(line, column)
        @state = :started
      end

      cell = @board.cell(line, column)
      return if cell.revealed_or_flagged?

      cell.reveal

      @state = :over if cell.mine?

      spread(line, column) if cell.blank?

      check_win_conditions
    end

    def flag(line, column)
      return if @state == :new

      @board.cell(line, column).flag

      check_win_conditions
    end

    def chord(line, column)
      return if @state == :new

      neighbourhood = @board.neighbours(line, column)
      mine_count = neighbourhood.select(&:mine?).count
      flag_count = neighbourhood.select(&:flagged?).count

      spread(line, column) if flag_count >= mine_count
    end

    ##
    # When revealing a blank square, it's safe to revel everything around you,
    def spread(line, column)
      @board.neighbours(line, column).each do |cell|
        click(cell.line, cell.column)
      end
    end

    def check_win_conditions
      return if @board.tiles_left > @board.mines

      @state = :over
      @victory = :true
    end

    def still_playing?
      @state != :over
    end

    def victory?
      @victory
    end
  end
end
