require_relative 'tile'
require 'byebug'
class Board
  attr_accessor :grid

  def initialize(grid, bomb_amount)
    @grid = grid
    @bomb_amount = bomb_amount

    generate_board

  end

  def self.new_board(size = 5, bomb_amount = 5)
    grid = Array.new(size, 0) { Array.new(size, 0) }
    bomb_locations = []
    until bomb_locations.length == bomb_amount
      bomb_locations << [rand(size),rand(size)]
      bomb_locations.uniq!
    end
    bomb_locations.each do |loc|
      grid[loc[0]][loc[1]] = 1
    end
    Board.new(grid, bomb_amount)
  end


  def generate_board
    grid.each_with_index do |row, i|
      row.each_with_index do |col, j|
        grid[i][j] == 1 ? grid[i][j] = Tile.new(self,[i,j], true) : grid[i][j] = Tile.new(self,[i,j], false)
      end
    end
    grid
  end

  def render_board
    grid.each do |rows|
      rows.each do |tile|
        if tile.is_flagged?
          print "F"
        elsif tile.is_revealed?
          if tile.has_bomb?
            print "B"
          elsif tile.fringe?
            print tile.neighbor_bomb_count
          else
            print "_"
          end
        else
          print "*"
        end
      end
      puts "\n"
    end
  end

  def get_move
    #take string, return move array
    puts "Please type in a location"
    pos = gets.chomp.split(",").map(&:to_i)
    until valid_move?(pos)
    end
    pos
  end

  def process_move
    #update grid based on move

    pos = get_move
    return false if win?
    return false if lose?(pos)
    reveal_tiles(pos)
    true
  end

  def reveal_tiles(pos)
    # neighbor_array = []
    # neighbor_array << grid[pos[0]][pos[1]]
    # curr_tile = neighbor_array.first
    # until neighbor_array.empty? reveal_tiles(curr_tile.location)
    #
    #   neighbor_array.shift
    #
    #   if curr_tile.fringe? && !curr_tile.has_bomb?
    #     curr_tile.reveal
    #   elsif !curr_tile.has_bomb? && !curr_tile.is_revealed?
    #     curr_tile.reveal
    #     neighbor_array << curr_tile.neighbors
    #   end
    #
    # end
    # puts "Revealing tiles... #{pos}"
    grid[pos[0]][pos[1]].reveal

    neighbors = grid[pos[0]][pos[1]].neighbors

    unless neighbors.nil?
      neighbors.each do |tile|
        tile.reveal
        # reveal_tiles(tile.location) if !tile.fringe?
      end
    end
  end

  def valid_move?(pos)
    #make sure move is valid
    valid = pos.all? { |loc| loc >= 0 && loc < grid.size }
    puts "Invalid location, please try again" unless valid
    valid
  end

  def flag_tile(loc)
    x, y = loc
    if grid[x][y].is_revealed?
      puts "Cannot flag this location"
    else
      !grid[x][y].is_flagged
    end
  end


  def win?
    #check grid for any remaining unrevealed tiles that aren't bombs
    grid.each do |rows|
      rows.each do |tile|
          return false unless tile.is_revealed? || tile.has_bomb?
      end
    end
    puts "You won!!!"
    true
  end

  def lose?(loc)
    #check if loc tile has_bomb?
    x, y = loc
    if grid[x][y].has_bomb?
      grid[x][y].bombed
      grid[x][y].reveal
      puts "Game over!!"
      return true
    end
    false
  end


  def run
    render_board
    while process_move
      render_board
    end
    render_board
  end

end
