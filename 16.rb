data = ARGF.gets.chars.map { |char| sprintf("%04b", char.to_i(16)) }.join.chars.map(&:to_i)
#puts data.inspect

def get_bits(data, size)
  num = data.shift(size).join.to_i(2)
  #puts num
  num

end

def read_packet(data)
  version = get_bits(data, 3)
  type_id = get_bits(data, 3)

  $v += version

  if type_id == 4
    bits = []
    loop do
      hdr = data.shift
      bits.concat data.shift(4)
      break if hdr == 0
    end
    literal = bits.join.to_i(2)
    literal.to_s
  else
    op = case type_id
    when 0
      'sum'
    when 1
      'inject(:*)'
    when 2
      'min'
    when 3
      'max'
    when 5
      '_gt'
    when 6
      '_lt'
    when 7
      '_eq'
    end
    ltid = data.shift
    subpackets = []
    if ltid == 0
      length = get_bits(data, 15)
      subdata = data.shift(length)
      until subdata.empty?
        subpackets << read_packet(subdata)
      end
    else
      n_subpackets = get_bits(data, 11)
      n_subpackets.times do
        subpackets << read_packet(data)
      end
    end
    "[#{subpackets.join(', ')}].#{op}"
  end

end

$v = 0

#puts "version sum: #{$v}"

class Array
  def _lt
    self[0] < self[1] ? 1 : 0
  end

  def _gt
    self[0] > self[1] ? 1 : 0
  end

  def _eq
    self[0] == self[1] ? 1 : 0
  end
end

puts eval(read_packet(data))
