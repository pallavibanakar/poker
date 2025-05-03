# frozen_string_literal: true

$LOAD_PATH << './lib'

require './games_evaluator'

filepath = '/home/starlekar/Downloads/poker-challenge-ruby/poker-challenge-ruby/poker.txt'

poker = GamesEvaluator.new(filepath: filepath)
poker.process

poker.print_results
