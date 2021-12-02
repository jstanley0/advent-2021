x = 0
z = 0
ARGF.each_line do |line|
  dir, val = line.split
  val = val.to_i
  case dir
  when 'up'
    z -= val
  when 'down'
    z += val
  when 'forward'
    x += val
  when 'backward'
    x -= val
  end
end

puts x * z
