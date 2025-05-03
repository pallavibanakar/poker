# frozen_string_literal: true

require 'poker/hand'

module Poker
  # Evaluates winner based on ranks and card values
  class WinnerEvaluator
    def initialize(player_one_cards, player_two_cards)
      @first_player_rank, @first_player_values = Poker::Hand.new(player_one_cards).rank
      @second_player_rank, @second_player_values = Poker::Hand.new(player_two_cards).rank
    end

    def call
      if @first_player_rank > @second_player_rank
        :player_one
      elsif @first_player_rank < @second_player_rank
        :player_two
      else
        tiebreaker
      end
    end

    def tiebreaker
      @first_player_values.zip(@second_player_values).each do |v1, v2|
        return :player_one if v1 > v2
        return :player_two if v2 > v1
      end
      :draw
    end
  end
end
