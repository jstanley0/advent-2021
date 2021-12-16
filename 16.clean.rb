require 'byebug'

class BitReader
  def initialize(hexdata)
    @data = [hexdata].pack("H*")
    @byte = 0
    @bit = 0x80
  end

  def empty?
    @byte >= @data.size
  end

  def get(size)
    val = 0
    until empty?
      byte = @data[@byte].ord
      while @bit > 0 && size > 0
        val <<= 1
        val |= 1 if (byte & @bit) != 0
        @bit >>= 1
        size -= 1
      end
      break if size == 0
      @byte += 1
      @bit = 0x80
    end
    val
  end
end

class LimitedBitReader
  def initialize(bit_reader, size)
    @bits = bit_reader
    @size = size
  end

  def empty?
    @size <= 0
  end

  def get(size)
    @size -= size
    @bits.get(size)
  end
end

def read_packet(bits)
  _version = bits.get(3)
  type_id = bits.get(3)

  if type_id == 4
    num = 0
    loop do
      hdr = bits.get(1)
      num <<= 4
      num |= bits.get(4)
      break if hdr == 0
    end
    num
  else
    values = []
    ltid = bits.get(1)
    if ltid == 0
      length = bits.get(15)
      sub_bits = LimitedBitReader.new(bits, length)
      until sub_bits.empty?
        values << read_packet(sub_bits)
      end
    else
      num_values = bits.get(11)
      num_values.times do
        values << read_packet(bits)
      end
    end

    case type_id
    when 0; values.sum
    when 1; values.inject(:*)
    when 2; values.min
    when 3; values.max
    when 5; values[0] > values[1] ? 1 : 0
    when 6; values[0] < values[1] ? 1 : 0
    when 7; values[0] == values[1] ? 1 : 0
    end
  end
end

puts read_packet(BitReader.new(ARGF.gets.chomp))
