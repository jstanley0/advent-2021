require_relative 'skim'

def move_cucumbers(map)
  og_map = map

  new_map = Skim.new(map.width, map.height, '.')

  map.each do |v, x, y|
    if v == '>'
      xr = (x + 1) % map.width
      if map[xr, y] == '.'
        new_map[xr, y] = '>'
      else
        new_map[x, y] = '>'
      end
    elsif v != '.'
      new_map[x, y] = v
    end
  end

  map = new_map
  new_map = Skim.new(map.width, map.height, '.')

  map.each do |v, x, y|
    if v == 'v'
      yr = (y + 1) % map.height
      if map[x, yr] == '.'
        new_map[x, yr] = 'v'
      else
        new_map[x, y] = 'v'
      end
    elsif v != '.'
      new_map[x, y] = v
    end
  end

  return nil if new_map.flatten == og_map.flatten
  new_map
end

map = Skim.read

iters = 0
loop do
  puts iters
  #map.print
  map = move_cucumbers(map)
  iters += 1
  break unless map
end

puts iters
