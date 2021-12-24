require 'byebug'

def rect_code(ranges)
  "translate([#{ranges[0].first},#{ranges[1].first},#{ranges[2].first}]) cube([#{ranges[0].size},#{ranges[1].size},#{ranges[2].size}]);\n"
end

scad = ""
ARGF.lines.map { |line|
  cmd, ranges = line.split(" ", 2)
  ranges = ranges.split(",").map{|r|r.split("=").last}.map{|r|Range.new(*r.split("..").map(&:to_f).map { |x| x / 1000.0 })}
  [cmd, rect_code(ranges)] }
.chunk_while { |a, b| a[0] == b[0] }
.each do |codes|
  scad = if codes[0].first == 'on'
    "union() {\n#{scad}\n#{codes.map(&:last).join}}\n"
  else
    "difference() {\n#{scad}\n#{codes.map(&:last).join}}\n"
  end
end

puts scad
