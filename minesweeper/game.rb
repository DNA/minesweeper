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
      @board.grid
    end

    def click(column, line)
      if @state == :new
        @board.populate(column, line)
        @state = :started
      end

      return if @board.revealed_or_flagged?(column, line)

      cell = @board.reveal(column, line)

      @state = :over if cell[:type] == :mine

      spread(column, line) if cell[:type] == :blank

      check_win_conditions
    end

    def flag(column, line)
      return if @state == :new

      @board.flag(column, line)

      check_win_conditions
    end

    def chord(column, line)
      return if @state == :new

      neighbourhood = @board.neighbours(column, line)
      mine_count = neighbourhood.select { |c| c[:type] == :mine }.count
      flag_count = neighbourhood.select { |c| c[:state] == :flagged }.count

      spread(column, line) if flag_count >= mine_count
    end

    ##
    # When revealing a blank square, it's safe to revel everything around you,
    def spread(column, line)
      @board.neighbours(column, line).each do |cell|
        click(cell[:column], cell[:line])
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
