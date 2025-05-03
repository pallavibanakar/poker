# frozen_string_literal: true

require 'poker/exceptions'
require 'poker/winner_evaluator'

# Reads games data from file and process them in batches and decides winner
class GamesEvaluator
  BATCH_SIZE = 100

  attr_reader :results

  def initialize(filepath:)
    @filepath = filepath
    @results = Hash.new(0)
  end

  def process
    games = []
    File.foreach(@filepath) do |line|
      games << line.chomp

      if games.size == BATCH_SIZE
        process_batches(games)
        games.clear
      end
    end
    process_batches(games) unless games.empty?
  end

  def print_results
    puts @results
    if @results[:player_one] > @results[:player_two]
      puts 'Player 1 is the Winner'
    elsif @results[:player_one] < @results[:player_two]
      puts 'Player 2 is the Winner'
    else
      puts 'Game is Draw'
    end
  end

  private

  def process_batches(games)
    games.each do |game|
      winner = evaluate_game(game)
      @results[winner] += 1
    rescue Poker::InvalidGameException, Poker::InvalidHandCountException => e
      puts "Invalid game: #{game.inspect} (#{e.class})"
    end
  end

  def evaluate_game(game)
    player_one_cards, player_two_cards = fetch_hands_from_game(game)
    Poker::WinnerEvaluator.new(player_one_cards, player_two_cards).call
  end

  def fetch_hands_from_game(game)
    raise Poker::InvalidGameException unless game.is_a?(String)

    cards = game.split
    raise Poker::InvalidHandCountException unless (cards.count % 5).zero?

    [cards.first(5), cards.last(5)]
  end
end
