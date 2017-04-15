module Minesweeper
  ##
  # This class handle the board state
  class Board
    ##
    # Official sizes for time-based World Ranking
    # For more info check http://www.minesweeper.info/worldranking.html
    SIZES = {
      beginner: {
        columns: 8,
        lines: 8,
        mines: 10
      },
      intermediate: {
        columns: 16,
        lines: 16,
        mines: 40
      },
      expert: {
        columns: 30,
        lines: 16,
        mines: 99
      }
    }.freeze

    attr_accessor :grid

    def initialize(columns:, lines:, mines:)
      @columns = columns
      @lines = lines
      @mines = mines

      validate_board
    end

    def validate_board
      return if @mines <= max_mines

      raise BoardError, "Exceeded mine count for #{@columns}x#{@lines} "\
                        "board (max: #{max_mines})"
    end

    def max_mines
      (@columns - 1) * (@lines - 1)
    end

    ##
    # If the board isn't initialized, send a default starter board
    def board_nil
      Array.new(@columns) do
        Array.new(@lines) do
          { state: :hidden }
        end
      end
    end
  end
end
