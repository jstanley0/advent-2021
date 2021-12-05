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

def draw_vline(points, x, y0, y1)
  (y0..y1).each do |y|
    plot_point(points, x, y)
  end
end

def draw_hline(points, y, x0, x1)
  (x0..x1).each do |x|
    plot_point(points, x, y)
  end
end

def draw_diagonal(points, line)
  dx = (line[1][0] > line[0][0]) ? 1 : -1
  dy = (line[1][1] > line[0][1]) ? 1 : -1
  x = line[0][0]
  y = line[0][1]
  loop do
    plot_point(points, x, y)
    break if x == line[1][0]
    x += dx
    y += dy
  end
end

lines.each do |line|
  if line[0][0] == line[1][0]
    draw_vline(points, line[0][0], *([line[0][1], line[1][1]].sort))
  elsif line[0][1] == line[1][1]
    draw_hline(points, line[0][1], *([line[0][0], line[1][0]].sort))
  else
    draw_diagonal(points, line)
  end
end

puts points.values.select { |v| v > 1 }.count
