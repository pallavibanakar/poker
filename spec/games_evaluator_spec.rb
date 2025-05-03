# frozen_string_literal: true

require 'spec_helper'
require_relative '../games_evaluator'

RSpec.describe GamesEvaluator do
  let(:fake_path) { 'fake_file.txt' }

  before do
    allow(Poker::WinnerEvaluator).to receive(:new)
      .with(any_args)
      .and_return(instance_double(Poker::WinnerEvaluator, call: :player_one))
  end

  describe '#process' do
    context 'with valid game lines' do
      it 'processes all games and tallies the result' do
        file_lines = [
          '8C TS KC 9H 4S 7D 2S 5D 3S AC',
          '5C AD 5D AC 9C 7C 5H 8D TD KS'
        ]

        allow(File).to receive(:foreach).with(fake_path).and_yield(file_lines[0]).and_yield(file_lines[1])

        evaluator = described_class.new(filepath: fake_path)
        evaluator.process

        expect(evaluator.results[:player_one]).to eq(2)
      end
    end

    context 'with mixed valid and invalid lines' do
      it 'skips invalid lines and logs error' do
        file_lines = [
          '5C AD 5D AC 9C 7C 5H 8D TD KS',
          '8C TS KC 9H 4S 7D 2S 5D 3S'
        ]

        allow(File).to receive(:foreach).with(fake_path).and_yield(file_lines[0]).and_yield(file_lines[1])

        evaluator = described_class.new(filepath: fake_path)
        expect { evaluator.process }.to output(/Invalid game/).to_stdout

        expect(evaluator.results[:player_one]).to eq(1)
      end
    end

    context 'when there is an exception in evaluate process' do
      it 'rescues InvalidGameException and InvalidHandCountException' do
        allow(File).to receive(:foreach).with(fake_path).and_yield('8C TS KC 9H 4S 7D 2S 5D 3S AC')

        allow(Poker::WinnerEvaluator).to receive(:new).and_raise(Poker::InvalidGameException)

        evaluator = described_class.new(filepath: fake_path)

        expect { evaluator.process }.not_to raise_error
      end

      it 'raises any other error' do
        allow(File).to receive(:foreach).with(fake_path).and_yield('8C TS KC 9H 4S 7D 2S 5D 3S AC')

        allow(Poker::WinnerEvaluator).to receive(:new).and_raise(StandardError)

        evaluator = described_class.new(filepath: fake_path)

        expect { evaluator.process }.to raise_error(StandardError)
      end
    end
  end

  describe '#print_results' do
    it 'prints the winner based on results' do
      evaluator = described_class.new(filepath: fake_path)
      evaluator.results[:player_one] = 3
      evaluator.results[:player_two] = 1

      expect { evaluator.print_results }.to output(/Player 1 is the Winner/).to_stdout
    end

    it 'prints draw when results are tied' do
      evaluator = described_class.new(filepath: fake_path)
      evaluator.results[:player_one] = 2
      evaluator.results[:player_two] = 2
      expect { evaluator.print_results }.to output(
        include('{:player_one=>2, :player_two=>2}', 'Game is Draw')
      ).to_stdout
    end
  end
end
