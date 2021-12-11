require_relative 'skim'

draw = gets.split(',').map(&:to_i)
gets

boards = Skim.read_many(num: true, sep: ' ')

def win?(board)
  board.rows.any? { |row| row.all? { |i| i >= 1000 } } ||
    board.cols.any? { |col| col.all? { |i| i >= 1000 } }
end

def mark_number(board, num)
  board.transform! do |val|
    val == num ? val + 1000 : val
  end
  board.print

  win?(board)
end

def score_board(board)
  board.flatten.select { |val| val < 1000 }.sum
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
