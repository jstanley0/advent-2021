ARGF.gets =~ /target area: x=(-?\d+\.\.-?\d+), y=(-?\d+\.\.-?\d+)/
$target_x = eval $1
$target_y = eval $2

def fire_probe(dx, dy)
  x = 0
  y = 0
  max_y = 0

  loop do
    x += dx
    y += dy
    max_y = y if y > max_y

    return max_y if $target_x.include?(x) && $target_y.include?(y)
    return nil if x > $target_x.max || y < $target_y.min

    dx -= 1 if dx > 0
    dy -= 1
  end
end

works = 0
max_y = 0
(0..1000).each do |dx|
  (-300..1000).each do |dy|
    y = fire_probe(dx, dy)
    works += 1 if y
    if y && y > max_y
      max_y = y
      puts "record of #{max_y} reached with #{dx},#{dy}"
    end
  end
end

puts max_y
puts works
