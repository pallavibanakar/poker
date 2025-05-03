# frozen_string_literal: true

require 'poker/exceptions'
require 'poker/winner_evaluator'

# Reads games data from file and process them in batches and decides winner
class GamesEvaluator
  BATCH_SIZE = 100

  attr_reader :results

  def initialize(filepath:, players_count: 2)
    @filepath = filepath
    @results = Hash.new(0)
    @players_count = players_count
    @cards_per_hand = 5
  end

  def process
    raise Poker::FileNotFoundException unless File.exist?(@filepath)

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
    max_score = @results.values.max
    winners = @results.select { |_, score| score == max_score }.keys

    if winners.size == 1
      puts "#{format_player_name(winners.first)} is the Winner"
    else
      puts "Game is Draw between: #{winners.map { |p| format_player_name(p) }.join(', ')}"
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
    Poker::WinnerEvaluator.new(fetch_hands_from_game(game)).call
  end

  def fetch_hands_from_game(game)
    raise Poker::InvalidGameException unless game.is_a?(String)

    cards = game.split
    raise Poker::InvalidHandCountException if cards.size != @players_count * @cards_per_hand

    cards.each_slice(@cards_per_hand).to_a
  end

  def format_player_name(symbol)
    symbol.to_s.gsub('_', ' ').split.map(&:capitalize).join(' ')
  end
end
