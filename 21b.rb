
class DeterministicDie
  def initialize
    @val = 0
    @roll_count = 0
  end

  def roll
    @val += 1
    @val = 1 if @val > 100
    @roll_count += 1
    @val
  end

  attr_accessor :roll_count
end


scores = [0, 0]
positions = [5, 9]

die = DeterministicDie.new
player = 0

while scores.max < 1000
  roll = die.roll + die.roll + die.roll
  positions[player] += roll
  positions[player] %= 10
  scores[player] += positions[player] + 1
  puts scores.inspect

  player = (player + 1) % 2
end

puts scores.min * die.roll_count
