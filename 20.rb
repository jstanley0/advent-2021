require_relative 'skim'

algo = ARGF.gets.chomp
ARGF.gets
raise "bad algo" unless algo.size == 512

image = Skim.read.pad(101, '.')

def process(image, algo)
  dest = Skim.new(image.width - 2, image.height - 2)
  (1...image.height - 1).each do |y|
    (1...image.width - 1).each do |x|
      pixels = image.data[y - 1][(x - 1)..(x + 1)].join
      pixels += image.data[y][(x - 1)..(x + 1)].join
      pixels += image.data[y + 1][(x - 1)..(x + 1)].join
      val = pixels.tr('.#', '01').to_i(2)
      dest[x - 1, y - 1] = algo[val]
    end
  end
  dest
end

50.times do
  image = process image, algo
end
image.print
puts image.flatten.count('#')

