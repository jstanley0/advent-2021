data = []
ARGF.each_line do |line|
  data << line.strip
end

gamma = ''
epsilon = ''

size = data.last.size
size.times do |bit|
  ones = data.count { |line| line[bit] == '1' }
  if ones > data.size - ones
    gamma << '1'
    epsilon << '0'
  else
    gamma << '0'
    epsilon << '1'
  end
end

puts gamma.to_i(2) * epsilon.to_i(2)

def oxygen(data, pos = 0)
  puts data.inspect
  return data[0] if data.size == 1
  raise "oops" if pos >= data.first.size

  sub = []
  ones = data.count { |line| line[pos] == '1' }
  zeroes = data.size - ones
  puts "position: #{pos}, ones: #{ones}, zeroes: #{zeroes}"
  sub = data.select { |line| line[pos] == (ones >= zeroes ? '1' : '0') }

  oxygen(sub, pos + 1)
end

def co2(data, pos = 0)
  puts data.inspect
  return data[0] if data.size == 1
  raise "oops" if pos >= data.first.size

  sub = []
  ones = data.count { |line| line[pos] == '1' }
  zeroes = data.size - ones
  puts "position: #{pos}, ones: #{ones}, zeroes: #{zeroes}"
  sub = data.select { |line| line[pos] == (ones < zeroes ? '1' : '0') }

  co2(sub, pos + 1)
end

puts "---"
puts oxygen(data)
puts co2(data)
puts oxygen(data).to_i(2) * co2(data).to_i(2)
