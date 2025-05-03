# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Poker::WinnerEvaluator, type: :integration do
  subject(:evaluator) { described_class.new(hand_player_one, hand_player_two) }

  let(:hand_player_one) { %w[5H 5C 6S 7S KD] }
  let(:hand_player_two) { %w[2C 3S 8S 8D TD] }

  describe '#call' do
    it 'when both player have pairs decides winner based on highest pair value' do
      expect(evaluator.call).to eq(:player_two)
    end

    context 'when both players have high card rank' do
      let(:hand_player_one) { %w[5D 8C 9S JS AC] }
      let(:hand_player_two) { %w[2C 5C 7D 8S QH] }

      it 'decides winner based on higest value card' do
        expect(evaluator.call).to eq(:player_one)
      end
    end

    context 'when both have different ranks' do
      let(:hand_player_one) { %w[2D 9C AS AH AC] }
      let(:hand_player_two) { %w[3D 6D 7D TD QD] }

      it 'decides winner based on higest rank' do
        expect(evaluator.call).to eq(:player_two)
      end
    end

    context 'when both players have pairs and same pair values' do
      let(:hand_player_one) { %w[4D 6S 9H QH QC] }
      let(:hand_player_two) { %w[3D 6D 7H QD QS] }

      it 'decides winner based on next higest value card' do
        expect(evaluator.call).to eq(:player_one)
      end
    end

    context 'when both players have full house rank' do
      let(:hand_player_one) { %w[2H 2D 4C 4D 4S] }
      let(:hand_player_two) { %w[3C 3D 3S 9S 9D] }

      it 'decides winner based on higest 3 of a kind value card' do
        expect(evaluator.call).to eq(:player_one)
      end
    end

    context 'when both players have same rank and values' do
      let(:hand_player_one) { %w[AC KC QC JC TC] }
      let(:hand_player_two) { %w[AC KC QC JC TC] }

      it 'returns :draw' do
        expect(evaluator.call).to eq(:draw)
      end
    end
  end
end
