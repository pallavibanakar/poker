# 🃏 Poker Game Evaluator

A Ruby-based application to evaluate poker games from a file and determine winners among 2 or more players based on standard poker hand rankings.

---

## 📦 Features

- Supports 2 or more players per game
- Evaluates hand ranks using standard poker rules
- Handles large files in batches
- Graceful error handling for invalid games or hands
- Displays final tally of wins and overall winner(s)

---

## 🛠️ Tech Stack

- **Language**: Ruby
- **Testing**: RSpec

---

## 📥 Installation

### 1. Clone the repo

```bash
git clone git@github.com:pallavibanakar/poker.git
cd poker
```

### 2. Install dependencies

```bash
bundle install
```
Make sure you have bundler installed:
gem install bundler

## Run

The application can be executed with example file given 
OR
Change the file path in main.rb

```bash
ruby main.rb
```
## Test

```bash
rspec
```
## 🧠 Implementation

### `GamesEvaluator`

- **Purpose**: 
  Parses a file containing poker games and determines the winner for each game.

- **How It Works**:
  - Accepts a file path and a player count as input.
  - Reads the file line by line, processing games in batches of 100 for efficiency.
  - Each line contains space-separated card values representing a full game.
  - Cards are evenly divided among players. If the line is malformed or the card count is incorrect, it raises appropriate exceptions.
  - For valid lines, it delegates winner determination to the `WinnerEvaluator` and tracks the number of wins for each player.

---

## `WinnerEvaluator`

- **Purpose**: 
  Determines the winner of a single poker game based on hand rankings.

- **How It Works**:
  - Takes an array of player hands as input.
  - Calls the `Hand` class to calculate each player's rank and tiebreaker values.
  - Determines the highest-ranking hand. If multiple players share the top rank and tiebreaker values, the result is a draw.
  - Otherwise, returns the identifier of the winning player.

---

## `Hand`

- **Purpose**: 
  Evaluates a single hand of cards and assigns it a rank according to poker rules.

- **How It Works**:
  - Accepts an array of 5 card strings, e.g., `['5D', '6C', 'KD', 'JC', '2S']`.
  - Separates the values and suits of the cards.
  - Determines the hand's rank (e.g., flush, straight, full house).
  - Sorts the card values for use in tiebreakers.
  - Returns both the rank and sorted values for winner comparison.

---
