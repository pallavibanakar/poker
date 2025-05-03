# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Poker::WinnerEvaluator do
  subject(:evaluator) { described_class.new(%i[player_one player_two]) }

  let(:hand_double_first_player) { instance_double(Poker::Hand) }
  let(:hand_double_second_player) { instance_double(Poker::Hand) }

  before do
    allow(Poker::Hand).to receive(:new).with(:player_one).and_return(hand_double_first_player)
    allow(Poker::Hand).to receive(:new).with(:player_two).and_return(hand_double_second_player)
  end

  context 'when player one has a higher rank' do
    it 'returns :player_one' do
      allow(hand_double_first_player).to receive(:rank).and_return([5, [10, 8, 6]])
      allow(hand_double_second_player).to receive(:rank).and_return([3, [14, 13, 12]])

      expect(evaluator.call).to eq('player_1')
    end
  end

  context 'when player two has a higher rank' do
    it 'returns 2' do
      allow(hand_double_first_player).to receive(:rank).and_return([2, [9, 8, 7]])
      allow(hand_double_second_player).to receive(:rank).and_return([4, [5, 4, 3]])

      expect(evaluator.call).to eq('player_2')
    end
  end

  context 'when ranks are equal and player one wins by first highest value' do
    it 'returns :player_one' do
      allow(hand_double_first_player).to receive(:rank).and_return([3, [13, 8, 6]])
      allow(hand_double_second_player).to receive(:rank).and_return([3, [12, 8, 6]])

      expect(evaluator.call).to eq('player_1')
    end
  end

  context 'when ranks are equal and player two wins by second highest value' do
    it 'returns :player_two' do
      allow(hand_double_first_player).to receive(:rank).and_return([3, [13, 7, 6]])
      allow(hand_double_second_player).to receive(:rank).and_return([3, [13, 8, 6]])

      expect(evaluator.call).to eq('player_2')
    end
  end

  context 'when both ranks and values are the same' do
    it 'returns :draw' do
      allow(hand_double_first_player).to receive(:rank).and_return([2, [10, 8, 6]])
      allow(hand_double_second_player).to receive(:rank).and_return([2, [10, 8, 6]])

      expect(evaluator.call).to eq(:draw)
    end
  end
end
