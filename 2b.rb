x = 0
aim = 0
z = 0
ARGF.each_line do |line|
  dir, val = line.split
  val = val.to_i
  case dir
  when 'up'
    aim -= val
  when 'down'
    aim += val
  when 'forward'
    x += val
    z += aim * val
  end
end

puts x * z
