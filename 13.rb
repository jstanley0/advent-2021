require 'set'
require_relative 'skim'

coords = Set.new
ARGF.each_line do |line|
  line.chomp!
  break if line.empty?
  coords << line.split(",").map(&:to_i)
end

folds = []
ARGF.each_line do |line|
  if line =~ /fold along ([xy])=(\d+)/
    folds << [$1, $2.to_i]
  else
    break
  end
end

def fold(fold, coords)
  new_coords = Set.new
  if fold.first == 'y'
    coords.each do |coord|
      if coord[1] > fold[1]
        new_coords.add [coord[0], 2 * fold[1] - coord[1]]
      else
        new_coords.add coord
      end
    end
  else
    coords.each do |coord|
      if coord[0] > fold[1]
        new_coords.add [2 * fold[1] - coord[0], coord[1]]
      else
        new_coords.add coord
      end
    end
  end
  new_coords
end

folds.each do |f|
  coords = fold(f, coords)
end

w = coords.map { |c| c[0] }.max + 1
h = coords.map { |c| c[1] }.max + 1
puts "dimensions: #{w} x #{h}"

skim = Skim.new(w, h, sep: ' ')
coords.each do |x, y|
  skim[x, y] = '#'
end

skim.print

