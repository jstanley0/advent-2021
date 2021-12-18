require 'byebug'
homework = ARGF.lines.map(&:chomp)

def add(l, r)
  n = "[#{l},#{r}]"
  reduce(n)
end

def find_quad_nest(n)
  ss = 0
  while (match = n[ss..].match(/\[\d+,\d+\]/))
    pos = ss + match.begin(0)
    nest = 0
    (0...pos).each do |i|
      if n[i] == '['
        nest += 1
      elsif n[i] == ']'
        nest -= 1
      end
    end
    if nest >= 4
      return pos...(ss + match.end(0))
    end
    ss += match.end(0)
  end
  nil
end

def regex_range_match(s, re)
  if (match = s.match(re))
    match.begin(0)...match.end(0)
  end
end

def find_double_digit(n)
  regex_range_match(n, /\d{2,}/)
end

def reduce(n)
  #puts "attempting to reduce #{n}"
  loop do
    if (range = find_quad_nest(n))
      pair = eval n[range]
      raise "eek" unless pair.is_a?(Array) && pair.size == 2

      before = n[0...range.first]
      left_num_range = regex_range_match(before.reverse, /\d+/)
      if left_num_range
        left_num_range = (before.size - left_num_range.last)...(before.size - left_num_range.first)
        left_num = before[left_num_range].to_i + pair[0]
        before[left_num_range] = left_num.to_s
      end

      after = n[range.last..]
      right_num_range = regex_range_match(after, /\d+/)
      if right_num_range
        right_num = after[right_num_range].to_i + pair[1]
        after[right_num_range] = right_num.to_s
      end

      n = before + "0" + after
      #puts "-- explodes to #{n}"
    elsif (range = find_double_digit(n))
      num = n[range].to_i
      n[range] = "[#{num/2},#{num/2 + num%2}]"
      #puts "-- splits to   #{n}"
    else
      break
    end
  end
  n
end


def magnitude(thing)
  if thing.is_a?(String)
    magnitude(eval thing)
  elsif thing.is_a?(Array)
    3 * magnitude(thing[0]) + 2 * magnitude(thing[1])
  else
    thing
  end
end

puts magnitude(homework.inject { |sum, n| add(sum, n) })

maxg = 0
homework.each do |l|
  homework.each do |r|
    mag = magnitude(add(l, r))
    maxg = [mag, maxg].max

    mag = magnitude(add(r, l))
    maxg = [mag, maxg].max
  end
end
puts maxg
