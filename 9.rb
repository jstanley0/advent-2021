map = []
ARGF.each_line do |line|
  map << line.strip
end

lows = []

risk = 0
map.each_with_index do |row, y|
  row.chars.each_with_index do |c, x|
    adj = []
    adj << map[y - 1][x] if y > 0
    adj << map[y + 1][x] if y < map.size - 1
    adj << map[y][x - 1] if x > 0
    adj << map[y][x + 1] if x < row.size - 1
    if c < adj.min
      risk += c.to_i + 1
      lows << [y, x]
    end
  end
end
puts risk

def find_basin_size(map, y, x)
  return 0 if y < 0 || y >= map.size
  return 0 if x < 0 || x >= map[0].size
  return 0 if map[y][x] == '9'
  sz = 1
  map[y][x] = '9'
  sz += find_basin_size(map, y - 1, x)
  sz += find_basin_size(map, y + 1, x)
  sz += find_basin_size(map, y, x - 1)
  sz += find_basin_size(map, y, x + 1)
  sz
end

basins = lows.map { |coords| find_basin_size(map, *coords) }.sort
puts basins.inspect
puts basins[-3..].inject(:*)


