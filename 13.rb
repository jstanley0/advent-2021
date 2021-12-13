require 'set'
require_relative 'skim'

Coord = Struct.new(:x, :y)
Fold = Struct.new(:axis, :val)

coords = Set.new
ARGF.each_line do |line|
  line.chomp!
  break if line.empty?
  coords << Coord.new(*line.split(",").map(&:to_i))
end

folds = []
ARGF.each_line do |line|
  if line =~ /fold along ([xy])=(\d+)/
    folds << Fold.new($1, $2.to_i)
  else
    break
  end
end

def fold(fold, coords)
  new_coords = Set.new
  if fold.axis == 'y'
    coords.each do |coord|
      if coord.y > fold.val
        new_coords.add Coord.new(coord.x, 2 * fold.val - coord.y)
      else
        new_coords.add coord
      end
    end
  else
    coords.each do |coord|
      if coord.x > fold.val
        new_coords.add Coord.new(2 * fold.val - coord.x, coord.y)
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

w = coords.map(&:x).max + 1
h = coords.map(&:y).max + 1
puts "dimensions: #{w} x #{h}"

skim = Skim.new(w, h, sep: ' ')
coords.each do |c|
  skim[*c] = '#'
end

skim.print

