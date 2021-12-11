require_relative 'skim'

map = Skim.read num: true

def flash_octopus(map, x, y)
  count = 1
  map[x, y] = -1 # can only flash once
  map.nabes(x, y) do |ov, ox, oy|
    next if ov < 0
    map[ox, oy] += 1
    if map[ox, oy] > 9
      count += flash_octopus(map, ox, oy)
    end
  end
  count
end

def flash(map)
  count = 0

  # 1. inc by 1
  map.transform! { |val| val + 1 }

  # 2. flash over 9
  map.each do |val, x, y|
    if val > 9
      count += flash_octopus(map, x, y)
    end
  end

  # 3. reset
  map.transform! do |val|
    val < 0 ? 0 : val
  end

  #map.print

  count
end

count = 0
#100.times do
step = 0
loop do
  count += flash(map)
  step += 1
  break if map.all?(&:zero?)
end
#puts count
puts step

