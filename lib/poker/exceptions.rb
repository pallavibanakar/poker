# frozen_string_literal: true

module Poker
  # InvalidGameException for invalid type of data
  class InvalidGameException < StandardError
    def initialize(msg = 'Invalid game; must be String input')
      super
    end
  end

  # InvalidHandCountException for invalid hands count
  class InvalidHandCountException < StandardError
    def initialize(msg = 'Invalid hands count in game')
      super
    end
  end
end
