polymer = gets.strip
gets

rules = ARGF.lines.inject({}) do |h, line|
  stuff = line.split(' -> ')
  h[stuff[0]] = stuff[1].strip
  h
end


def polymerize(polymer, rules)
  new_poly = ""
  chars = polymer.chars
  chars.each_cons(2) do |l, r|
    thing = l + r
    blah = rules[thing]
    new_poly << l + blah
  end
  new_poly << chars.last
  new_poly
end

10.times do
  polymer = polymerize(polymer, rules)
end

stats = polymer.chars.group_by(&:itself).values.map(&:size)
puts stats.max - stats.min

