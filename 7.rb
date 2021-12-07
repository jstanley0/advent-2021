crabs = gets.split(',').map(&:to_i)
min_cost = nil
(crabs.min..crabs.max).each do |x|
  cost = crabs.map { |cx| (cx - x).abs }.sum
  #puts "cost for #{x} = #{cost}"
  min_cost = cost if min_cost.nil? || cost < min_cost
end
puts min_cost

