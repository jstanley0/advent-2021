prev = nil
increased = 0
ARGF.lines.each do |line|
  i = line.to_i
  increased += 1 if prev && i > prev
  prev = i
end
puts increased
