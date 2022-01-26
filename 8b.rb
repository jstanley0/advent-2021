require 'byebug'

  REAL_DIGITS = { 'cf' => 1,

                'acf' => 7,

                'bcdf' => 4,

                'acdeg' => 2,
                'acdfg' => 3,
                'abdfg' => 5,

                'abcefg' => 0,
                'abdefg' => 6,
                'abcdfg' => 9,

                'abcdefg' => 8
  }

# frequencies of segments

# a 8
# c 8

# b 6

# d 7
# g 7

# e 4

# f 9


def decode_num(digits, num)
  numbers = [nil] * 10

  digits.each_with_index do |digit, i|
    case digit.size
    when 2
      numbers[1] = digit
    when 3
      numbers[7] = digit
    when 4
      numbers[4] = digit
    when 7
      numbers[8] = digit
    end
  end

  wire_map = {}
  wire_map['a'] = (numbers[7].chars - numbers[1].chars)[0]

  # 2, 3, and 5
  fives = digits.select { |digit| digit.size == 5 }
  adg = fives[0].chars & fives[1].chars & fives[2].chars

  # 0, 6, and 9
  sixes = digits.select { |digit| digit.size == 6 }
  abfg = sixes[0].chars & sixes[1].chars & sixes[2].chars

  wire_map['d'] = (adg - abfg)[0]

  bf = abfg - adg

  wire_map['b'] = (bf - numbers[1].chars)[0]

  wire_map['f'] = (bf - [wire_map['b']])[0]

  freq = Hash.new(0)
  digits.join.chars.each do |char|
    freq[char] += 1
  end

  raise "foo" unless wire_map['b'] == freq.key(6)
  raise "baz" unless wire_map['f'] == freq.key(9)
  wire_map['e'] = freq.key(4)

  # still need c and g
  ac = freq.select { |seg, f| f == 8 }.keys
  wire_map['c'] = (ac - [wire_map['a']])[0]

  dg = freq.select { |seg, f| f == 7 }.keys
  wire_map['g'] = (dg - [wire_map['d']])[0]

  wire_map = wire_map.invert
  num.map { |segs|
    real_segs = segs.chars.map { |wrong_char| wire_map[wrong_char] }.sort.join
    REAL_DIGITS[real_segs]
  }.join.to_i
end

n = 0
ARGF.each_line do |line|
  blah, bleh = line.split('|')
  blah = blah.split
  bleh = bleh.split
  n += decode_num(blah, bleh)
end
puts n
