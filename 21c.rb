GameState = Struct.new(:positions, :scores) do
  def game_over?
    scores.max >= 21
  end

  def bifurcate_universe
    GameState.new(positions.dup, scores.dup)
  end

  def child(player, roll)
    new_state = bifurcate_universe
    new_state.positions[player] = (new_state.positions[player] + roll) % 10
    new_state.scores[player] += new_state.positions[player] + 1
    new_state
  end
end

# note that I have subtracted 1 from the positions here
initial = GameState.new([3, 7], [0, 0])
#initial = GameState.new([5, 9], [0, 0])

universes = { initial => 1 }
player = 0

loop do
  puts "universe count: distinct #{universes.size}, total #{universes.values.sum} (game over in #{universes.keys.count(&:game_over?) * 100 / universes.keys.size}%)"
  new_universes = {}

  in_play = false
  universes.each do |state, count|
    if state.game_over?
      new_universes[state] ||= 0
      new_universes[state] += count
    else
      in_play = true
      [1,2,3].repeated_permutation(3) do |dice|
        new_state = state.child(player, dice.sum)
        new_universes[new_state] ||= 0
        new_universes[new_state] += count
      end
    end
  end
  break unless in_play

  universes = new_universes
  player = (player + 1) % 2
end

p0_states = universes.keys.select { |k| k.scores[0] > k.scores[1] }
p1_states = universes.keys.select { |k| k.scores[1] > k.scores[0] }

puts "player 0 wins in #{universes.values_at(*p0_states).sum} universes"
puts "player 1 wins in #{universes.values_at(*p1_states).sum} universes"
