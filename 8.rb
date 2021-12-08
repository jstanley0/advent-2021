n = 0
ARGF.each_line do |line|
  blah, bleh = line.split('|')
  blah = blah.split
  bleh = bleh.split
  bleh.each do |word|
    if [2, 3, 4, 7].include?(word.size)
      n += 1
    end
  end
end
puts n
