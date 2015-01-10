# https://github.com/betweenparentheses/project_data_structures/blob/master/knightstravails.rb

#Your task is to build a function knight_moves that shows the simplest possible way to get from one square to
#another by outputting all squares the knight will stop on along the way.
#You can think of the board as having 2-dimensional coordinates.
#Your function would therefore look like:
#knight_moves([0,0],[1,2]) == [[0,0],[1,2]]
#knight_moves([0,0],[3,3]) == [[0,0],[1,2],[3,3]]
#knight_moves([3,3],[0,0]) == [[3,3],[1,2],[0,0]]

module KnightsTravail

Square = Struct.new(:position, :moves, :parent)
class Square
  def to_s
    "position: #{position}, moves: #{moves}"
  end
end

class MoveTree
  attr_reader :start_node
  
  def initialize(start)
    @start_node = Square.new(start, [], nil)
  end
  
  def next_moves(square)
    possibles = possible_moves(square[:position])
    possibles.each {|possible| square[:moves] << Square.new(possible, [], square)}
  end
  
  def find_path_to(target)
    queue = Array.new
    queue.unshift(@start_node)
    until queue.empty?
      current = queue.pop
      if target == current[:position]
        return current
      else
        next_moves(current) if current[:moves].empty?
        current[:moves].each {|move| queue.unshift(move)}
      end
    end
    nil
  end
  
  private
  
  #takes position in form [0-7, 0-7]
  #returns an array of all legal moves for a knight from one position
  def possible_moves(position)
    x, y = position[0], position[1]
    possibles = []
    
    move_grid(x,y).each {|move| possibles << move if move_legal?(move)}
    possibles
  end
    
  def move_grid(x, y)
    [[x+2, y-1], [x+2, y+1], [x-2, y+1], [x-2, y-1],
     [x+1, y+2], [x-1, y+2], [x+1, y-2], [x-1, y-2]]
  end

  #checks if a move is legal for a knight from the current location
  def move_legal?(move)
    return true if move[0].between?(0, 7) && move[1].between?(0,7)
    false
  end
end

#the core method. takes destination and destination as arrays of two-dimensional coordinates from 0 to 7

def knight_moves(start, target)
  tree = MoveTree.new(start)  
  destination = tree.find_path_to(target)
  trace_path_from(destination)
end

private

def trace_path_from(node)
  path = []
  until node.nil?
    path.unshift node[:position]
    node = node[:parent]
  end
  path
end

end

include KnightsTravail

#testing
p knight_moves([0,0],[1,2]) # => [[0,0],[1,2]]
p knight_moves([0,0],[3,3]) # => [[0,0],[1,2],[3,3]]
p knight_moves([3,3],[0,0]) # => [[3,3],[1,2],[0,0]]
p knight_moves([6,7], [3,5]) # => [[6, 7], [4, 6], [2, 7], [3, 5]]