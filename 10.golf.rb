BRACES = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }
ERRORS = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }

score = 0
completions = []
ARGF.each_line do |line|
  line = line.strip
  stack = []
  error = 0

  line.chars.each do |char|
    if BRACES.key?(char)
      # opening
      stack.push BRACES[char]
    else
      # closing
      if char == stack.last
        stack.pop
      else
        # syntax error!
        error = ERRORS[char]
        break
      end
    end
  end

  if error == 0
    completions << stack.reverse.inject(0) { |cs, cc| cs * 5 + " )]}>".index(cc) }
  else
    score += error
  end
end

puts score

completions.sort!
puts completions[completions.size / 2]
