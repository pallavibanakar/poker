# frozen_string_literal: true

require 'constants'

module Poker
  # Class for hand of each player with thier ranks and values sorted
  class Hand
    def initialize(cards)
      @cards = cards.map { |card| [CARD_VALUES[card[0]], card[1]] }
      @values = @cards.map(&:first).sort { |a, b| b <=> a }
      @suits = @cards.map(&:last)
      @value_counts = @values.tally
    end

    def rank
      return flush_type if flush?
      return [HAND_RANKS[:four_of_a_kind], groups] if count?(4)
      return [HAND_RANKS[:straight], @values] if straight_values?
      return set_type if count?(3)
      return pair_type if count?(2)

      [HAND_RANKS[:high_card], @values]
    end

    private

    def count?(num)
      @value_counts.values.include?(num)
    end

    def straight_values?
      true if @values.each_cons(2).all? { |a, b| a - 1 == b }
    end

    def flush?
      @suits.uniq.size == 1
    end

    def groups
      @value_counts.sort_by { |val, count| [-count, -val] }.map(&:first)
    end

    def flush_type
      return [HAND_RANKS[:royal_flush], @values] if @values == [14, 13, 12, 11, 10]
      return [HAND_RANKS[:straight_flush], @values] if straight_values?

      [HAND_RANKS[:flush], @values]
    end

    def pair_type
      return [HAND_RANKS[:two_pair], groups] if @value_counts.values.count(2) == 2

      [HAND_RANKS[:pair], groups]
    end

    def set_type
      return [HAND_RANKS[:full_house], groups] if count?(2)

      [HAND_RANKS[:three_of_a_kind], groups]
    end
  end
end
