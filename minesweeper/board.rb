module Minesweeper
  ##
  # This class handle the board state
  class Board
    ##
    # Official sizes for time-based World Ranking
    # For more info check http://www.minesweeper.info/worldranking.html
    SIZES = {
      beginner: {
        width: 8,
        height: 8,
        mines: 10
      },
      intermediate: {
        width: 16,
        height: 16,
        mines: 40
      },
      expert: {
        width: 30,
        height: 16,
        mines: 99
      }
    }.freeze

    attr_accessor :grid

    def initialize(width:, height:, mines:)
      @width = width
      @height = height
      @mines = mines

      validate_board
    end

    def validate_board
      return if @mines <= max_mines

      raise BoardError, "Exceeded mine count for #{@width}x#{@height} "\
                        "board (max: #{max_mines})"
    end

    def max_mines
      (@width - 1) * (@height - 1)
    end

    ##
    # If the board isn't initialized, send a default starter board
    def board_nil
      Array.new(@width) do
        Array.new(@height) do
          { state: :hidden }
        end
      end
    end
  end
end
