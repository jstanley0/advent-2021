map = []
ARGF.each_line do |line|
  map << line.strip.chars.map(&:to_i)
end

def flash_octopus(map, y, x)
  count = 1
  map[y][x] = -1 # can only flash once
  (-1..1).each do |dy|
    (-1..1).each do |dx|
      oy = y + dy
      ox = x + dx
      next if ox < 0 || oy < 0 || ox >= map[0].size || oy >= map.size
      next if map[oy][ox] < 0
      map[oy][ox] += 1
      if map[oy][ox] > 9
        count += flash_octopus(map, oy, ox)
      end
    end
  end
  count
end

def flash(map)
  count = 0

  # 1. inc by 1
  map.each_with_index do |row, y|
    row.each_with_index do |val, x|
      map[y][x] += 1
    end
  end

  # 2. flash over 9
  map.each_with_index do |row, y|
    row.each_with_index do |val, x|
      if val > 9
        count += flash_octopus(map, y, x)
      end
    end
  end

  # 3. reset
  map.each_with_index do |row, y|
    row.each_with_index do |val, x|
      if val < 0
        map[y][x] = 0
      end
    end
  end

  count
end

count = 0
#100.times do
step = 0
loop do
  count += flash(map)
  step += 1
  break if map.all? { |row| row.all?(&:zero?) }
end
#puts count
puts step

