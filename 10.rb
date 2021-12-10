BRACES = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }

score = 0
completions = []
ARGF.each_line do |line|
  line = line.strip
  open = []
  error = 0
  line.chars.each do |char|
    if BRACES.key?(char)
      # opening
      open.push char
    else
      # closing
      if BRACES.key(char) == open.last
        open.pop
      else
        # syntax error!
        error = case char
        when ')'
          3
        when ']'
          57
        when '}'
          1197
        when '>'
          25137
        end
        break
      end

    end
  end
  score += error
  if error == 0
    cs = 0
    open.reverse.each do |cc|
      cs = cs * 5 + case cc
      when '('
        1
      when '['
        2
      when '{'
        3
      when '<'
        4
      end
    end
    completions << cs
  end
end

puts score

completions.sort!
puts completions[completions.size / 2]
