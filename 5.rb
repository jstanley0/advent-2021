lines = []
ARGF.each_line do |line|
  # 0,9 -> 5,9
  p = line.split(" -> ")
  p = p.map { |point| point.split(',').map(&:to_i) }
  lines << p
end

#lines.select! { |p| p[0][0] == p[1][0] || p[0][1] == p[1][1] }

points = {}

def plot_point(points, x, y)
  points[[x, y]] ||= 0
  points[[x, y]] += 1
end

lines.each do |line|
  dx = line[1][0] <=> line[0][0]
  dy = line[1][1] <=> line[0][1]
  x = line[0][0]
  y = line[0][1]
  loop do
    plot_point(points, x, y)
    break if x == line[1][0] && y == line[1][1]
    x += dx
    y += dy
  end
end

puts points.values.count { |v| v > 1 }
