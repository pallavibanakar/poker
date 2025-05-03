# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Poker::Hand do
  def hand_rank(cards)
    described_class.new(cards).rank
  end

  it 'ranks high card correctly' do
    rank, values = hand_rank(%w[2H 5D 9C KD 7S])
    expect(rank).to eq(HAND_RANKS[:high_card])
    expect(values).to eq([13, 9, 7, 5, 2])
  end

  it 'ranks a pair with correct descending values' do
    rank, values = hand_rank(%w[2H 2D 5C 9S KD])
    expect(rank).to eq(HAND_RANKS[:pair])
    expect(values).to eq([2, 13, 9, 5])
  end

  it 'ranks two pair with correct ordering' do
    rank, values = hand_rank(%w[5H 5D 2C 2S KH])
    expect(rank).to eq(HAND_RANKS[:two_pair])
    expect(values).to eq([5, 2, 13])
  end

  it 'ranks three of a kind with correct value ordering' do
    rank, values = hand_rank(%w[3H 3D 3S 9C KD])
    expect(rank).to eq(HAND_RANKS[:three_of_a_kind])
    expect(values).to eq([3, 13, 9])
  end

  it 'ranks a straight with highest card first' do
    rank, values = hand_rank(%w[5H 6D 7C 8S 9H])
    expect(rank).to eq(HAND_RANKS[:straight])
    expect(values).to eq([9, 8, 7, 6, 5])
  end

  it 'ranks a flush with descending values' do
    rank, values = hand_rank(%w[2H 5H 9H KH 7H])
    expect(rank).to eq(HAND_RANKS[:flush])
    expect(values).to eq([13, 9, 7, 5, 2])
  end

  it 'ranks a full house with 3-of-a-kind value first' do
    rank, values = hand_rank(%w[6H 6D 6C 2S 2D])
    expect(rank).to eq(HAND_RANKS[:full_house])
    expect(values).to eq([6, 2])
  end

  it 'ranks four of a kind with four kind value first' do
    rank, values = hand_rank(%w[9H 9D 9S 9C 2D])
    expect(rank).to eq(HAND_RANKS[:four_of_a_kind])
    expect(values).to eq([9, 2])
  end

  it 'ranks a straight flush with top card' do
    rank, values = hand_rank(%w[5H 6H 7H 8H 9H])
    expect(rank).to eq(HAND_RANKS[:straight_flush])
    expect(values).to eq([9, 8, 7, 6, 5])
  end

  it 'ranks a royal flush with A high' do
    rank, values = hand_rank(%w[TH JH QH KH AH])
    expect(rank).to eq(HAND_RANKS[:royal_flush])
    expect(values).to eq([14, 13, 12, 11, 10])
  end
end
