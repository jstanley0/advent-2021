require_relative 'skim'
require 'pqueue'

HALL_ROW = 1
HALL_COLS = 1..11
WAIT_COLS = [1, 2, 4, 6, 8, 10, 11].freeze
CAVE_COLS = [3, 5, 7, 9].freeze
CAVES = {'A' => 3, 'B' => 5, 'C' => 7, 'D' => 9}.freeze
PODS = CAVES.invert.freeze
ENERGY = {'A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000}.freeze

def cave_rows(map)
  2..map.height - 2
end

def clear_path?(map, from_x, to_x)
  if from_x < to_x
    map[from_x+1..to_x, HALL_ROW].all? { |c| c == '.' }
  else
    map[to_x..from_x-1, HALL_ROW].all? { |c| c == '.' }
  end
end

def pod_to_move_out(map, x)
  y_range = cave_rows(map)
  y = y_range.first
  y += 1 while map[x, y] == '.'
  return nil if y > y_range.last

  pod = map[x, y]
  return y if CAVES[pod] != x

  (y + 1..y_range.last).each do |yb|
    blocked_pod = map[x, yb]
    return y if CAVES[blocked_pod] != x
  end

  false
end

def pods_to_move_out(map)
  coords = []
  CAVE_COLS.each do |x|
    y = pod_to_move_out(map, x)
    coords << [x, y] if y
  end
  coords
end

def wait_spots_for_pod(map, x)
  cols = []
  fail unless CAVE_COLS.include?(x)
  WAIT_COLS.each do |wait_x|
    cols << wait_x if clear_path?(map, x, wait_x)
  end
  cols
end

def move_pod_in?(map, x)
  cave_rows(map).each do |y|
    return false if map[x, y] != '.' && map[x, y] != PODS[x]
  end
  true
end

def pods_to_move_in(map)
  cols = []
  y = HALL_ROW
  HALL_COLS.each do |x|
    pod = map[x, y]
    next if pod == '.'

    home_x = CAVES[pod]
    fail unless home_x

    cols << x if move_pod_in?(map, home_x) && clear_path?(map, x, home_x)
  end
  cols
end

# returns [updated map, move cost] pair
def move_pod(map, from_x, from_y, to_x, to_y)
  pod = map[from_x, from_y]
  step_cost = ENERGY[pod]
  fail unless step_cost
  fail unless map[to_x, to_y] == '.'

  new_map = map.dup
  new_map[from_x, from_y] = '.'
  new_map[to_x, to_y] = pod

  distance = (to_x - from_x).abs + (to_y - from_y).abs
  [new_map, step_cost * distance]
end

def complete?(map)
  cave_rows(map).each do |y|
    CAVE_COLS.each do |x|
      return false unless map[x, y] == PODS[x]
    end
  end
  true
end

def remaining_cost_lower_bound(map)
  total = 0
  cave_rows(map).each do |y|
    CAVE_COLS.each do |x|
      pod = map[x, y]
      if pod != '.' && pod != PODS[x]
        total += ((y - HALL_ROW) + (x - CAVES[pod]).abs + 1) * ENERGY[pod]
      end
    end
  end
  HALL_COLS.each do |x|
    pod = map[x, HALL_ROW]
    if pod != '.'
      total += ((x - CAVES[pod]).abs + 1) * ENERGY[pod]
    end
  end
  total
end

map = Skim.read(rec: false)

QueueEntry = Struct.new(:map, :est_total_cost)

def map_key(map)
  map.flatten.join
end

def process_move(open_set, map, best_costs, cost_so_far, from_x, from_y, to_x, to_y)
  sub_map, step_cost = move_pod(map, from_x, from_y, to_x, to_y)
  running_cost = cost_so_far + step_cost
  key = map_key(sub_map)
  if best_costs[key].nil? || best_costs[key] > running_cost
    best_costs[key] = running_cost
    open_set.push QueueEntry.new(sub_map, running_cost + remaining_cost_lower_bound(sub_map))
  end
end

def search(map)
  open_set = PQueue.new do |a, b|
    a.est_total_cost < b.est_total_cost
  end
  open_set.push QueueEntry.new(map, remaining_cost_lower_bound(map))

  best_costs = { map_key(map) => 0 }

  until open_set.empty?
    current = open_set.pop
    cost_so_far = best_costs[map_key(current.map)]
    if complete?(current.map)
      return cost_so_far
    end

    pods_to_move_out(current.map).each do |from_x, from_y|
      wait_spots_for_pod(current.map, from_x).each do |to_x|
        process_move(open_set, current.map, best_costs, cost_so_far, from_x, from_y, to_x, HALL_ROW)
      end
    end

    pods_to_move_in(current.map).each do |from_x|
      pod = current.map[from_x, HALL_ROW]
      to_x = CAVES[pod]
      to_y = cave_rows(map).select { |y| current.map[to_x, y] == '.' }.max
      process_move(open_set, current.map, best_costs, cost_so_far, from_x, HALL_ROW, to_x, to_y)
    end
  end
end

puts search(map)
