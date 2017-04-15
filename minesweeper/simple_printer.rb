module Minesweeper
  ##
  # Simple ASCII board printer
  class SimplePrinter
    DEFAULT_SYMBOLS = {
      hidden: " \u2588",
      blank: '  ',
      bomb: ' *',
      flag: ' ?'
    }.freeze

    def initialize(custom_symbols = {})
      @symbols = DEFAULT_SYMBOLS.merge(custom_symbols)
    end

    def print_board(grid, x_ray: false)
      clear_cmd unless x_ray

      header = '  '
      0.upto(grid[0].length - 1) { |i| header << " #{i}" }
      puts header

      grid.each_with_index do |line, index|
        line_draw = line.map do |cell|
          check_symbol(cell, x_ray)
        end
        puts "#{index} #{line_draw.join}"
      end
    end

    def check_symbol(cell, x_ray)
      unless x_ray
        return @symbols[:hidden] if cell[:state] == :hidden
        return @symbols[:flag] if cell[:state] == :flagged
      end

      if cell[:type] == :number
        " #{cell[:value]}"
      else
        @symbols[cell[:type]]
      end
    end

    def clear_cmd
      system('clear') || system('cls')
    end
  end
end
