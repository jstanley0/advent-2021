# short for "ASCII Map"
# since this is a common pattern in AoC and I often screw it up

require 'byebug'

class Skim
  # yeah, this isn't very Encapsulated, but I need an escape hatch when time is of the essence
  attr_accessor :data, :sep

  # build an empty skim of the given size with the given value
  # optional separator will be used only for output
  def initialize(width = 0, height = 0, default = nil, sep: nil)
    @sep = sep
    @data = height.times.map { [default] * width }
  end

  # read a skim from src, stopping when an empty line or EOF is reached
  # kwargs:
  #  sep: if given, split input line on this separator. otherwise each character is an entry
  #  rec: require the skim to be rectangular (all rows are the same width)
  #  square: require the skim to be square (same width and height)
  #  num: treat the values as numeric
  # block:
  #  if given, transform each string on the way in
  def self.read(src = ARGF, sep: nil, rec: true, square: false, num: false)
    skim = Skim.new(sep: sep)
    data = []
    loop do
      line = src.gets
      break if line.nil?

      line.chomp!
      break if line.empty?

      ld = if sep.nil?
        line.chars
      else
        line.split(sep)
      end

      ld = ld.map(&:to_i) if num

      if block_given?
        ld = ld.map { |val| yield val }
      end

      data << ld
    end

    skim.data = data
    raise "data not rectangular" if (rec || square) && !skim.rectangular?
    raise "data not square" if square && !skim.square?

    skim
  end

  # like #read, but returns an array of Skims separated by blank lines
  # if count is nil, read until EOF, otherwise read that many
  def self.read_many(src = ARGF, count: nil, sep: nil, rec: true, square: false, num: false, &block)
    skims = []
    loop do
      skim = Skim.read(src, sep: sep, rec: rec, square: square, num: num, &block)
      break if skim.empty?
      skims << skim
      break if skims.size == count
    end
    raise "wrong number of Skims. expected #{count}, got #{skims.size}" if count && skims.size != count
    skims
  end

  # width of the given row (if initialized with +rec+ then all rows are the same width)
  def width(row = 0)
    data[row].size
  end

  def height
    data.size
  end

  def empty?
    data.empty?
  end

  def rectangular?
    data.empty? || data[1..].all? { |row| row.size == data[0].size }
  end

  def square?
    width == height
  end

  def flatten
    data.flatten
  end

  def rows
    dup.data
  end

  def cols
    rotate_ccw.data.reverse
  end

  def in_bounds?(x, y)
    x >= 0 && y >= 0 && y < height && x < width(y)
  end

  def print(stream = $stdout)
    delim = sep.to_s
    rec_width = flatten.map { |el| el.to_s.size }.max
    delim = ' ' if delim.empty? && rec_width > 1

    data.each do |row|
      stream.puts row.map { |val| "%*s" % [rec_width, val] }.join(delim)
    end
    stream.puts
  end

  def [](x, y)
    data[y][x]
  end

  def []=(x, y, val)
    data[y][x] = val
  end

  def dup
    other = Skim.new(sep: sep)
    other.data = data.map(&:dup)
    other
  end

  # yield each value with its coordinates
  def each
    data.each_with_index do |row, y|
      row.each_with_index do |val, x|
        yield val, x, y
      end
    end
  end

  def ==(rhs)
    data == rhs.data
  end

  def any?
    data.any? { |row| row.any? { |v| yield v } }
  end

  def all?
    data.all? { |row| row.all? { |v| yield v } }
  end

  # yield each value+coords and replace with block
  def transform!
    data.each_with_index do |row, y|
      row.each_with_index do |val, x|
        self[x, y] = yield val, x, y
      end
    end
    self
  end

  # yield neighbors (val, x, y) of the given element
  # if `diag` is false, only yield orthogonal ones (not diagonals)
  def nabes(x, y, diag: true, &block)
    check_nabe(x - 1, y, &block)
    check_nabe(x + 1, y, &block)
    check_nabe(x, y - 1, &block)
    check_nabe(x, y + 1, &block)
    if diag
      check_nabe(x - 1, y - 1, &block)
      check_nabe(x - 1, y + 1, &block)
      check_nabe(x + 1, y - 1, &block)
      check_nabe(x + 1, y + 1, &block)
    end
  end

  private def check_nabe(x, y)
    yield self[x, y], x, y if in_bounds?(x, y)
  end

  # return a flat array of the values of the neighbors
  def nv(x, y, diag: true)
    vals = []
    nabes(x, y, diag: diag) do |val|
      vals << val
    end
    vals
  end

  def rotate_cw
    raise "not rectangular" unless rectangular?
    other = Skim.new(height, width, sep: sep)
    other.transform! do |_, x, y|
      self[y, height - x - 1]
    end
  end

  def rotate_ccw
    raise "not rectangular" unless rectangular?
    other = Skim.new(height, width, sep: sep)
    other.transform! do |_, x, y|
      self[width - y - 1, x]
    end
  end

  def flip_v
    other = Skim.new(sep: sep)
    other.data = data.map(&:dup).reverse
    other
  end

  def flip_h
    other = Skim.new(sep: sep)
    other.data = data.map(&:reverse)
    other
  end

end
