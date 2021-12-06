fish = gets.split(',').map(&:to_i)

def run_day(fish)
  new_fish = []
  fish.each_with_index do |f, i|
    if f == 0
      f = 6
      new_fish << 8
    else
      f -= 1
    end
    fish[i] = f
  end
  fish.concat(new_fish)
end

80.times do |x|
  run_day(fish)
#  puts fish.inspect
end

puts fish.size
