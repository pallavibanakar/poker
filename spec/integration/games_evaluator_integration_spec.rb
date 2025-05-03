# frozen_string_literal: true

require 'spec_helper'
require_relative '../../games_evaluator'

RSpec.describe GamesEvaluator do
  let(:file_path) { 'fake_file.txt' }

  let(:file_content) do
    [
      '5H 5C 6S 7S KD 2C 3S 8S 8D TD',
      '5D 8C 9S JS AC 2C 5C 7D 8S QH',
      '2D 9C AS AH AC 3D 6D 7D TD QD',
      '4D 6S 9H QH QC 3D 6D 7H QD QS',
      '2H 2D 4C 4D 4S 3C 3D 3S 9S 9D'
    ]
  end

  before do
    allow(File).to receive(:foreach).with(file_path).and_yield(file_content[0])
                                    .and_yield(file_content[1])
                                    .and_yield(file_content[2])
                                    .and_yield(file_content[3])
                                    .and_yield(file_content[4])
  end

  it 'correctly processes all games and prints results' do
    evaluator = described_class.new(filepath: file_path)
    evaluator.process

    expect(evaluator.results[:player_one]).to eq(3)
    expect(evaluator.results[:player_two]).to eq(2)
    expect(evaluator.results[:draw]).to eq(0)

    expect { evaluator.print_results }.to output(
      include('{:player_two=>2, :player_one=>3}', 'Player 1 is the Winner')
    ).to_stdout
  end
end
