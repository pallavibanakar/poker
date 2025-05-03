# frozen_string_literal: true

require 'poker/hand'

module Poker
  # Evaluates winner based on ranks and card values
  class WinnerEvaluator
    def initialize(players_hands)
      @scores = players_hands.map.with_index do |cards, idx|
        rank, values = Poker::Hand.new(cards).rank
        { player: "player_#{idx + 1}", rank: rank, values: values }
      end
    end

    def call
      top_score = @scores.max_by { |s| [s[:rank], s[:values]] }

      winners = @scores.select do |s|
        s[:rank] == top_score[:rank] && s[:values] == top_score[:values]
      end

      return :draw if winners.size > 1

      winners.first[:player]
    end
  end
end
