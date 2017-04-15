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

    def populate(column, line)
      @grid = board_nil

      generate_bombs(column, line)

      numerize_grid
    end

    ##
    # Since the first click is never a bomb, we populare the board using the
    # first click col/line as a safe click
    def generate_bombs(column, line)
      generated_mines = 0
      while generated_mines < @mines
        rline = rand(@lines)
        rcol = rand(@columns)

        next if @grid[rline][rcol][:type] == :bomb # Don't overwrite bomb
        next if rline == line && rcol == column # Don't put bomb on safe click

        @grid[rline][rcol][:type] = :bomb
        generated_mines += 1
      end
    end

    def numerize_grid
      @grid.each_with_index do |line, line_index|
        line.each_with_index do |cell, column_index|
          next if cell[:type] == :bomb

          near_bombs = neighbours(column_index, line_index)
                       .select { |n| n[:type] == :bomb }
                       .count

          if near_bombs > 0
            cell[:type] = :number
            cell[:value] = near_bombs
          else
            cell[:type] = :blank
          end
        end
      end
    end

    ##
    # Return all adjacents cells from an specific cell
    def neighbours(column, line)
      min_col, max_col, min_line, max_line = bound_check(column, line)
      neighbourhood = []

      # Iterate 3x3 block
      (min_line..max_line).each do |l|
        (min_col..max_col).each do |c|
          next if l == line && c == column # Skip itself

          neighbourhood << @grid[l][c].merge(line: l, column: c)
        end
      end

      neighbourhood
    end

    ##
    # Return min/max values for grid iteration
    def bound_check(column, line)
      # Columns bound-check
      min_col = 0
      min_col = column - 1 if column - 1 >= 0

      max_col = @columns - 1
      max_col = column + 1 if column + 1 < @columns

      # Lines bound check
      min_line = 0
      min_line = line - 1 if line - 1 >= 0

      max_line = @lines - 1
      max_line = line + 1 if line + 1 < @lines

      [min_col, max_col, min_line, max_line]
    end

    ##
    # If the board isn't initialized, send a default starter board
    def board_nil
      Array.new(@lines) do
        Array.new(@columns) do
          { state: :hidden }
        end
      end
    end
  end
end
