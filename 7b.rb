=begin
def cost_for_distance(distance)
  cost = 0
  inc = 1
  distance.times do
    cost += inc
    inc += 1
  end
  cost
end
=end

def cost_for_distance(distance)
  (distance * (1 + distance)) / 2
end

crabs = gets.split(',').map(&:to_i)
min_cost = nil
(crabs.min..crabs.max).each do |x|
  cost = crabs.map { |cx| cost_for_distance((cx - x).abs) }.sum
  #puts "cost for #{x} = #{cost}"
  min_cost = cost if min_cost.nil? || cost < min_cost
end
puts min_cost

