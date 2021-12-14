polymer = gets.strip
gets

rules = ARGF.lines.inject({}) do |h, line|
  stuff = line.split(' -> ')
  h[stuff[0]] = stuff[1].strip
  h
end

stats = polymer.chars.each_cons(2).inject({}) do |h, (l, r)|
  k = l + r
  h[k] ||= 0
  h[k] += 1
  h
end

def polymerize(stats, rules)
  new_stats = {}
  stats.each do |k, v|
    product = rules[k]

    lp = k[0] + product
    new_stats[lp] ||= 0
    new_stats[lp] += v

    rp = product + k[1]
    new_stats[rp] ||= 0
    new_stats[rp] += v
  end
  new_stats
end

40.times do |i|
  stats = polymerize(stats, rules)
end

# count the first letter...
counts = { polymer[0] => 1 }

# ... and the second letter of each pair
stats.each do |k, v|
  counts[k[1]] ||= 0
  counts[k[1]] += v
end

data = counts.values
puts data.max - data.min


