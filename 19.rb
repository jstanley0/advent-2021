require_relative 'skim'
require 'byebug'
require 'set'

Coord = Struct.new(:x, :y, :z) do
  def +(other)
    Coord.new(x + other.x, y + other.y, z + other.z)
  end

  def -(other)
    Coord.new(x - other.x, y - other.y, z - other.z)
  end

  def dist(other)
    dx = x - other.x
    dy = y - other.y
    dz = z - other.z
    Math.sqrt(dx * dx + dy * dy + dz * dz)
  end

  def manhattan_distance(other)
    (x - other.x).abs + (y - other.y).abs + (z - other.z).abs
  end

  def rotate_x
    Coord.new(x, -z, y)
  end

  def rotate_y
    Coord.new(z, y, -x)
  end

  def rotate_z
    Coord.new(-y, x, z)
  end
end

scanners = []

class Scanner
  attr_accessor :num, :coords, :location, :lines

  def initialize(num, coords = [], lines = [], location = Coord.new(0, 0, 0))
    self.num = num
    self.coords = coords
    self.location = location
    self.lines = lines
  end

  def self.read
    hdr = ARGF.gets
    return nil unless hdr =~ /--- scanner (\d+) ---/
    s = Scanner.new($1.to_i)
    loop do
      line = ARGF.gets&.strip
      break if line.nil? || line.empty?
      s.coords << Coord.new(*line.split(',').map(&:to_i))
    end
    s.compute_lines
    s
  end

  def compute_lines
    coords.combination(2).each do |a, b|
      lines << a.dist(b)
    end
  end

  def each_rotation
    # starting orientation: white up (yep, using a rubik's cube to visualize this)
    # this covers all permutations with red, green, blue, or orange on the +x axis
    # and we should end back where we started
    tc = coords.map(&:dup)
    4.times do
      4.times do
        yield tc
        tc.map!(&:rotate_x)
      end
      tc.map!(&:rotate_z)
    end
    raise "bad rotate" unless tc.eql? coords

    # now put white on +x
    tc.map!(&:rotate_y)
    4.times do
      yield tc
      tc.map!(&:rotate_x)
    end

    # and -x
    tc.map! { |coord| coord.rotate_y.rotate_y }
    4.times do
      yield tc
      tc.map!(&:rotate_x)
    end

    # and for good measure, go back to where we started
    tc.map!(&:rotate_y)
    raise "bad rotate" unless tc.eql? coords
  end

  def coords_relative_to(coord)
    coords.map { |c| c - coord }
  end

  # if successful, returns a new Scanner with coordinates transformed into the reference scanner's system
  # otherwise returns nil
  def transform(reference)
    reference.coords.each do |rcoord|
      rrcoords = reference.coords.map { |c| c - rcoord }
      each_rotation do |ucoords|
        ucoords.each do |ucoord|
          urcoords = ucoords.map { |c| c - ucoord }
          if (rrcoords & urcoords).size >= 12
            return Scanner.new(num, urcoords.map { |c| c + rcoord }, lines, rcoord - ucoord)
          end
        end
      end
    end

    nil
  end

end

while (scanner = Scanner.read)
  raise "missing scanner #{scanners.size}" unless scanner.num == scanners.size
  scanners << scanner
end

ns = scanners.size
chart = Skim.new(ns, ns)
(0...ns).each do |i|
  (0...i).each do |j|
    chart[i, j] = (scanners[i].lines & scanners[j].lines).size
  end
end
chart.print

solved = scanners.shift(1)
until scanners.empty?
  solved_scanner = nil
  scanners.each do |us|
    solved.each do |ss|
      common_lines = us.lines & ss.lines
      if common_lines.size >= 66
        solved_scanner = us.transform(ss)
      end
      puts "aligned #{us.num} with #{ss.num}" if solved_scanner
      break if solved_scanner
    end
    break if solved_scanner
  end
  break unless solved_scanner
  solved << solved_scanner
  scanners.delete_if { |s| s.num == solved_scanner.num }
end

beacons = Set.new
solved.each do |ss|
  ss.coords.each do |c|
    beacons << c
  end
end

puts beacons.size

maxd = 0
solved.each do |a|
  solved.each do |b|
    maxd = [maxd, a.location.manhattan_distance(b.location)].max
  end
end
puts maxd
