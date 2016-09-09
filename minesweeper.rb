require_relative 'board'

class Minesweeper
  attr_reader :board

  def initialize
    @board = Board.new_board

  end

  def play
    board.run
  end
end


minesweeper = Minesweeper.new
minesweeper.play
