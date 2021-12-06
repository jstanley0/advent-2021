fish = gets.split(',').map(&:to_i)

ft = {}
(0..8).each do |t|
  ft[t] = fish.count(t)
end

def run_day(ft)
  {
    0 => ft[1],
    1 => ft[2],
    2 => ft[3],
    3 => ft[4],
    4 => ft[5],
    5 => ft[6],
    6 => ft[7] + ft[0],
    7 => ft[8],
    8 => ft[0]
  }
end

256.times do |x|
  ft = run_day(ft)
end

puts ft.values.sum
