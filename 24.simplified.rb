A = [12, 13, 13, -2, -10, 13, -14, -5, 15, 15, -14, 10, -14, -5]
B = [1, 1, 1, 26, 26, 1, 26, 26, 1, 1, 26, 1, 26, 26]
C = [7, 8, 10, 4, 4, 6, 11, 13, 1, 8, 4, 13, 4, 14]

def stage(n, w, z)
  if z % 26 + A[n] == w
    z / B[n]
  else
    26 * (z / B[n]) + w + C[n];
  end
end

def run(num)
  digs = num.to_s.split("").map(&:to_i)
  z = 0
  14.times do |i|
    w = digs.shift
    z = otherstage i, w, z
    puts "#{"%2d" % i}. w=#{w} z=#{z}"
  end
  z
end
