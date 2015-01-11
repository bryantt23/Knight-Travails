# https://github.com/betweenparentheses/project_data_structures/blob/master/knightstravails.rb

#Your task is to build a function knight_moves that shows the simplest possible way to get from one square to
#another by outputting all squares the knight will stop on along the way.
#You can think of the board as having 2-dimensional coordinates.
#Your function would therefore look like:
#knight_moves([0,0],[1,2]) == [[0,0],[1,2]]
#knight_moves([0,0],[3,3]) == [[0,0],[1,2],[3,3]]
#knight_moves([3,3],[0,0]) == [[3,3],[1,2],[0,0]]

module KnightsTravail

# http://ruby-doc.org/core-2.2.0/Struct.html
# i think it is creating a structure with parameters

=begin
http://stackoverflow.com/questions/6337897/what-is-the-colon-operator-in-ruby
Symbols are a way to represent strings and names in ruby.
=end

Square = Struct.new(:position, :moves, :parent)

class Square

# i think method just displays info about position & moves
  def to_s
    "position: #{position}, moves: #{moves}"
  end
end

class MoveTree
# instance variable
  attr_reader :start_node
  
  def initialize(start)
# new square, with start, empty array parameters
    @start_node = Square.new(start, [], nil)
  end
  
# square parameter
  def next_moves(square)
# possibles is possible moves based on square parameter with array of position
    possibles = possible_moves(square[:position])
    
    
# i think it is making each element in possibles by adding the method?
    possibles.each {|possible| square[:moves] << Square.new(possible, [], square)}
  end
  
# looks like it is a bfs because uses queue
# target is parameter
  def find_path_to(target)
# queue is new array
    queue = Array.new
# .unshift moves objects to the front 
    queue.unshift(@start_node)
# until the queue is empty
    until queue.empty?
      
# current is equal to popping the queue (first in queue)
      current = queue.pop
      if target == current[:position]
        return current
      else
# look for next movies if current moves is empty? not sure
        next_moves(current) if current[:moves].empty?
# i think it might be finding current moves by unshifting the queue? not sure
# seems to be adding moves to the queue. idk
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
    
# possibles is formed by adding only legal moves
# call move grid method below
    move_grid(x,y).each {|move| possibles << move if move_legal?(move)}
    possibles
  end
    
# list of possible knight moves
  def move_grid(x, y)
    [[x+2, y-1], [x+2, y+1], [x-2, y+1], [x-2, y-1],
     [x+1, y+2], [x-1, y+2], [x+1, y-2], [x-1, y-2]]
  end

  #checks if a move is legal for a knight from the current location
  def move_legal?(move)
# i think it makes sure it stays on the board
    return true if move[0].between?(0, 7) && move[1].between?(0,7)
    false
  end
end

#the core method. takes destination and destination as arrays of two-dimensional coordinates from 0 to 7

def knight_moves(start, target)
# i think it's the first position?
  tree = MoveTree.new(start)  
# destination is use the tree then call the find the path with target parameter
  destination = tree.find_path_to(target)
# trace path from destination parameter
  trace_path_from(destination)
end

private

def trace_path_from(node)
  path = []
# until node is nil
  until node.nil?
# take the path array and put the position at the front  
    path.unshift node[:position]
# noe is equal to the parent?
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