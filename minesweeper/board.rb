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

    attr_accessor :grid, :mines

    def initialize(lines:, columns:, mines:)
      @columns = columns
      @lines = lines
      @mines = mines

      validate_board

      @grid = start_grid
    end

    def validate_board
      return if @mines <= max_mines

      raise BoardError, "Exceeded mine count for #{@columns}x#{@lines} "\
                        "board (max: #{max_mines})"
    end

    def max_mines
      (@columns - 1) * (@lines - 1)
    end

    def populate(line, column)
      generate_mines(line, column)

      numerize_grid
    end

    def cell(line, column)
      @grid[line][column]
    end

    def tiles_left
      @grid.flatten.delete_if(&:visible?).count
    end

    ##
    # Since the first click is never a mine, we populare the board using the
    # first click col/line as a safe click
    def generate_mines(line, column)
      generated_mines = 0
      while generated_mines < @mines
        rline = rand(@lines)
        rcol = rand(@columns)

        next if @grid[rline][rcol].mine? # Don't overwrite mine
        next if rline == line && rcol == column # Don't put mine on safe click

        @grid[rline][rcol].type = :mine
        generated_mines += 1
      end
    end

    def numerize_grid
      @grid.each_with_index do |line, l_idx|
        line.each_with_index do |cell, c_idx|
          next if cell.mine? # Don't overwrite mine

          near_mines = neighbours(l_idx, c_idx).select(&:mine?).count

          cell.value = near_mines if near_mines > 0
        end
      end
    end

    ##
    # Return all adjacents cells from an specific cell
    def neighbours(line, column)
      min_col, max_col, min_line, max_line = bound_check(line, column)
      neighbourhood = []

      # Iterate 3x3 block
      (min_line..max_line).each do |l|
        (min_col..max_col).each do |c|
          next if l == line && c == column # Skip itself

          @grid[l][c].position(line: l, column: c)
          neighbourhood << @grid[l][c]
        end
      end

      neighbourhood
    end

    ##
    # Return min/max values for grid iteration
    def bound_check(line, column)
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
    # If the board isn't initialized, set a default starter board
    def start_grid
      Array.new(@lines) { Array.new(@columns) { Cell.new } }
    end
  end
end
