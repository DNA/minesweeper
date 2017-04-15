module Minesweeper
  ##
  # Simple ASCII board printer
  class SimplePrinter
    DEFAULT_SYMBOLS = {
      hidden: " \u2588",
      blank: '  ',
      bomb: ' *'
    }.freeze

    def initialize(custom_symbols = {})
      @symbols = DEFAULT_SYMBOLS.merge(custom_symbols)
    end

    def print_board(grid, x_ray: false)
      system 'clear' or system 'cls'

      header = '  '
      0.upto(grid[0].length - 1) { |i| header << " #{i}" }
      puts header

      grid.each_with_index do |line, index|
        line_draw = line.map do |cell|
          if cell[:state] == :hidden && !x_ray
            @symbols[:hidden]
          elsif cell[:type] == :number
            " #{cell[:value]}"
          else
            @symbols[cell[:type]]
          end
        end
        puts "#{index} #{line_draw.join}"
      end
    end
  end
end
