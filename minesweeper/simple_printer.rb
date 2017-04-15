module Minesweeper
  ##
  # Simple ASCII board printer
  class SimplePrinter
    DEFAULT_SYMBOLS = {
      hidden: " \u2588",
      blank: '  ',
      mine: ' *',
      flag: ' ?'
    }.freeze

    def initialize(custom_symbols = {})
      @symbols = DEFAULT_SYMBOLS.merge(custom_symbols)
    end

    def print_board(grid, x_ray: false)
      clear_cmd unless x_ray

      print_header(grid[0].count)

      grid.each_with_index do |line, index|
        index = index.to_s.rjust(2, '0') if grid.count > 9
        line_draw = line.map { |cell| check_symbol(cell, x_ray) }
        puts "#{index} #{line_draw.join}"
      end
    end

    def print_header(collumn_count)
      top_header = ''
      header = ''

      if collumn_count > 9
        0.upto(collumn_count - 1) { |i| top_header << " #{i / 10}" }
        puts "   #{top_header}"
      end

      0.upto(collumn_count - 1) { |i| header << " #{i % 10}" }

      if top_header.empty?
        puts "  #{header}"
      else
        puts "   #{header}"
      end
    end

    def check_symbol(cell, x_ray)
      unless x_ray
        return @symbols[:hidden] if cell.hidden?
        return @symbols[:flag] if cell.flagged?
      end

      if cell.number?
        " #{cell.value}"
      else
        @symbols[cell.type]
      end
    end

    def clear_cmd
      system('clear') || system('cls')
    end
  end
end
