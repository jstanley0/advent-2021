require_relative 'skim'
require 'pqueue'

map = Skim.read(num: true)
Coord = Struct.new(:x, :y)

start = Coord.new(0, 0)
fin = Coord.new(map.width - 1, map.height - 1)

QueueEntry = Struct.new(:coord, :dist)

def dist(c1, c2)
  (c1.x - c2.x).abs + (c1.y - c2.y).abs
end

def search(map, start, goal)
  open_set = PQueue.new do |a, b|
    a.dist < b.dist
  end
  open_set.push QueueEntry.new(start, dist(start, goal))

  g_score = {}
  g_score[start] = 0

  until open_set.empty?
    current = open_set.pop
    #puts "searching from #{current.coord}"
    if current.coord == goal
      return g_score[current.coord]
    end

    map.nabes(*current.coord, diag: false) do |val, x, y|
      nabe = Coord.new(x, y)
      g_candidate = g_score[current.coord] + val
      if g_score[nabe].nil? || g_score[nabe] > g_candidate
        g_score[nabe] = g_candidate
        open_set.push QueueEntry.new(nabe, g_candidate + dist(nabe, goal))
      end
    end

  end
end

puts search(map, start, fin)

def rejigger(val, xm, ym)
  val = val + xm + ym
  while val > 9
    val -= 9
  end
  val
end

def asplode(map)
  new_map = Skim.new(map.width * 5, map.height * 5)
  5.times do |xm|
    5.times do |ym|
      map.width.times do |x|
        map.height.times do |y|
          new_map[xm * map.width + x, ym * map.height + y] = rejigger(map[x, y], xm, ym)
        end
      end
    end
  end
  new_map
end

new_map = asplode(map)
#new_map.print
fin = Coord.new(new_map.width - 1, new_map.height - 1)

puts search(new_map, start, fin)
