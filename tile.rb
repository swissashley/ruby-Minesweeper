class Tile
attr_reader :board, :has_bomb, :is_revealed, :is_flagged, :location

  def initialize(board, location, has_bomb = false)
    @board = board
    @location = location
    @has_bomb = has_bomb
    @is_revealed = false
    @is_flagged = false
  end

  def bombed
    @has_bomb = true
  end
  def has_bomb?
    @has_bomb
  end

  def is_revealed?
    @is_revealed
  end

  def inspect

  end

  def reveal
    @is_revealed = true
  end

  def flag
    @is_flagged = true
  end

  def is_flagged?
    @is_flagged
  end

  def fringe?
    neighbor_bomb_count > 0
  end

  def neighbors

    neighbors = []
    x_lower = (location[0] - 1 >= 0) ? (location[0] - 1) : 0
    y_lower = (location[1] - 1 >= 0) ? (location[1] - 1) : 0

    # puts "xl: #{x_lower}, yl: #{y_lower}"
    (x_lower..(x_lower + 2)).each do |x|
      (y_lower..(y_lower + 2)).each do |y|
        neighbors << @board.grid[x][y] unless location == [x,y] || @board.grid[x][y].has_bomb? || @board.grid[x][y].is_revealed?
      end
    end
      neighbors
  end

  def neighbor_bomb_count
    bomb_count = 0
    unless neighbors.nil?
      neighbors.each do |tile|
        bomb_count += 1 if tile.has_bomb?
      end
    end

    bomb_count
  end


end
