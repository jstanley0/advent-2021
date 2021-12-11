def read_board
  rows = []
  return if gets.nil?
  5.times do
    rows << gets.split.map(&:to_i)
  end
  rows
end

draw = gets.split(',').map(&:to_i)
boards = []
loop do
  board = read_board
  break unless board
  boards << board
end

def win?(board)
  return true if board.any? { |row| row.all? { |i| i >= 1000 } }

  5.times do |col|
    w = true
    5.times do |row|
      if board[row][col] < 1000
        w = false
        break
      end
    end
    return true if w
  end

  false
end

def mark_number(board, num)
  board.size.times do |row|
    row.size.times do |col|
      board[row][col] += 1000 if board[row][col] == num
    end
  end
  pp board

  win?(board)
end

def score_board(board)
  board.map { |row| row.select { |num| num < 1000 }.sum }.sum
end

wins = (0...boards.size).to_a

draw.each do |num|
  puts "calling #{num}"
  boards.each_with_index do |board, index|
    if mark_number(board, num)
      wins = wins - [index]
      if wins.empty?
        puts score_board(board) * num
        exit
      end
    end
  end
end
