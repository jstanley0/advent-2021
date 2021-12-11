require_relative 'skim'

map = Skim.read

lows = []
risk = 0
map.each do |c, x, y|
  if c < map.nv(x, y, diag: false).min
    risk += c.to_i + 1
    lows << [x, y]
  end
end
puts risk

def find_basin_size(map, x, y)
  return 0 if map[x, y] == '9'
  sz = 1
  map[x, y] = '9'
  map.nabes(x, y, diag: false) do |_, a, b|
    sz += find_basin_size(map, a, b)
  end
  sz
end

basins = lows.map { |coords| find_basin_size(map, *coords) }.sort
puts basins.inspect
puts basins[-3..].inject(:*)
