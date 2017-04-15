module Minesweeper
  ##
  # Basic cell object, to track individual cell states
  class Cell
    attr_accessor :state, :type, :value, :line, :column

    def initialize(state: :hidden, type: :blank)
      @state = state
      @type = type
    end

    def value=(val)
      @type = :number
      @value = val
    end

    def position(line:, column:)
      @line = line
      @column = column
    end

    def revealed_or_flagged?
      %i(flagged visible).include? state
    end

    def reveal
      @state = :visible
    end

    def flag
      @state = :flagged
    end

    def hidden?
      state == :hidden
    end

    def flagged?
      state == :flagged
    end

    def visible?
      state == :visible
    end

    def number?
      type == :number
    end

    def mine?
      type == :mine
    end

    def blank?
      type == :blank
    end
  end
end
