prev = nil
window = []
increased = 0
ARGF.each_line do |line|
  i = line.to_i
  window << i
  if window.size == 3
    m = window.sum
    increased += 1 if prev && m > prev
    prev = m
    window.shift
  end
end
puts increased
