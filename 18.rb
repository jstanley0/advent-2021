homework = ARGF.lines.map { |line| eval line }


def add(l, r)
  l + r
end

def find_quad_nest(stringthing)
  stringthing.match(/\[\[\[\[(\[\d, \d\])/)
  nest_level = 0
  stringthing.chars.each_with_index do |char, i|
    if char == '['
      nest_level += 1
    elsif char == ']'
      nest_level -= 1
    end
    return i if nest_level == 5
  end
  nil
end

def reduce!(thing)
  stringthing = thing.inspect
  if (pos = find_quad_nest(stringthing))

  end
end


def magnitude(thing)
  if thing.is_a?(Array)
    3 * magnitude(thing[0]) + 2 * magnitude(thing[1])
  else
    thing
  end
end

