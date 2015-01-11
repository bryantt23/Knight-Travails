# https://github.com/donaldali/odin-ruby/tree/master/project_data_structs_alg/knights_travails

# structure with symbol parameters for position & path
PositionPath = Struct.new(:position, :path)

# Find shortest knight path between two chess board positions

# parameters are from & to
def knight_moves(from, to)
  
# return unless the input is valid
# so i guess if the input is not valid, then don't return & continue?
# recursion maybe?
  return unless input_valid?(from, to)
  
# path is equal to knight path with parameters from & to
  path = knight_path(from, to)

# call method to display path
  display_path path
end

# bfs because queue
# Find a shortest path a knight can take between two positions on a chess board
def knight_path(from, to)
# i think open queue is an array made of this structure, seems like object in java
  open_queue = [PositionPath.new( from, [copy(from)] )]
# discovered is array of from
  discovered = [from]

# until the open queue is empty
  until open_queue.empty?
# the current is the first in the queue
# .shift takes the first & removes it also 
    current = open_queue.shift

# return the current path if the current position is equal to to ? 
    return current.path if current.position == to

# i think it is calling the valid moves method, using current position as 
# the parameter, & for each call is 
    valid_moves(current.position).each do |move|

# i think if it is already included in discovered, don't have to worry about it
      unless discovered.include?(move)

# but if it is not discovered yet, then add the move to discovered
        discovered << move

# open queue gets pushed on it the make position path with paramters of current & move
        open_queue.push(make_position_path(current, move)) 
      end
    end
  end
  
end

# Create a PositionPath struct to hold a position and the path to that position
def make_position_path(current, new_position)

# new path is copy of current path & new position
  new_path = copy(current.path + [new_position])

# new position path takes parameters of new position & new path
  PositionPath.new(new_position, new_path) 
end


# valid moves takes from parameter
# Determine all valid position a knight can move to from a given position
def valid_moves(from)

# takes possible moves based on from parameter, 
# each move is checked to see if it leads a valid position
  possible_moves(from).select { |move| valid_position?(move) }
end

# Generate all possible knight moves (legal and illegal)
def possible_moves(from)
  positions = []

# knight moves

# not sure what pair means, maybe it's hash 1, hash 2? 
# maybe move 1 in a direction, perpendicular has to be 2 or -2?
# maybe move 2 in a direction, perpendicular has to be 1 or -1?
  pair = { 1 => [2, -2], 2 => [1, -1] }

# can only move 1 or 2 rows forwards or backwards
  row_change = [-2, -1, 1, 2]

# for each row change 
  row_change.each do |change|


# not exactly sure how to read this
# positions
    positions << add_positions(from, [change, pair[change.abs][0]])
    positions << add_positions(from, [change, pair[change.abs][1]])
  end
  positions
end

# Add row and column segments of two positions
def add_positions(pos1, pos2)
  [pos1[0] + pos2[0], pos1[1] + pos2[1]]
end


# make sure b/w 0 & 8?
# Ascertain if a position is legal on a chess board
def valid_position?(position)
  board_size = 8
  position[0].between?(0, board_size - 1) && position[1].between?(0, board_size - 1)
end


# check by using valid position method with parameters for from & to
# Ascertain the validity two inputted positions
def input_valid?(from, to)
  valid_position?(from) && valid_position?(to)
end

# Make a deep copy of an object (used on nested arrays here)
def copy object
  Marshal.load(Marshal.dump(object))
end

# Display the generated knight's path
def display_path path
  if path.length <= 1
    puts "You are already at your destination :-)"
    return
  end
  puts "You made it in #{path.length - 1} move#{path.length > 2 ? "s" : ""}! Here's your path:"
  path_string = ""
  path.each { |position| path_string += position.to_s + "-->" }
  path_string[-3..-1] = ""
  puts path_string
end


# knight_moves([0,0],[1,2]) # -> [[0,0],[1,2]]
# knight_moves([0,0],[3,3]) # -> [[0,0],[1,2],[3,3]]
# knight_moves([3,3],[0,0]) # -> [[3,3],[1,2],[0,0]]
# knight_moves([3,3],[4,3])