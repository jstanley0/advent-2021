def range_overlap(r1, r2)
  if r1.first < r2.first
    return nil if r1.last < r2.first
    r2.first..(r1.last < r2.last ? r1.last : r2.last)
  else
    return nil if r2.last < r1.first
    r1.first..(r2.last < r1.last ? r2.last : r1.last)
  end
end

Cube = Struct.new(:rx, :ry, :rz) do
  def volume
    rx.size * ry.size * rz.size
  end

  def intersection(other)
    ix = range_overlap(rx, other.rx)
    iy = ix && range_overlap(ry, other.ry)
    iz = iy && range_overlap(rz, other.rz)
    return iz && Cube.new(ix, iy, iz)
  end
end

add_cubes = []
sub_cubes = []

ARGF.lines.each do |line|
  cmd, ranges = line.split(" ", 2)
  ranges = ranges.split(",").map{|r|r.split("=").last}.map{|r|Range.new(*r.split("..").map(&:to_i))}

  to_add = []
  to_sub = []
  cube = Cube.new(*ranges)

  to_add << cube if cmd == 'on'
  add_cubes.each do |ac|
    if (intersect = cube.intersection(ac))
      to_sub << intersect
    end
  end
  sub_cubes.each do |sc|
    if (intersect = cube.intersection(sc))
      to_add << intersect
    end
  end

  add_cubes.concat to_add
  sub_cubes.concat to_sub
end

puts add_cubes.map(&:volume).sum - sub_cubes.map(&:volume).sum

