# https://github.com/thomasjnoe/knight-moves/blob/master/knight_moves.rb

# Class to hold the current position and path while traversing possible moves
# TO-DO: Change to Struct
class BoardSquare                 
  attr_accessor :position, :path  
  def initialize(position, path)
    @position = position
    @path = path
  end
end

def knight_moves(start, finish)
  # Check for invalid starting or finishing positions, and if start and finish are the same
  return "You entered an invalid starting position" unless is_valid_position?(start) 
  return "You entered an invalid ending position" unless is_valid_position?(finish)
  return "You're already on that position!" if start == finish

  queue = [BoardSquare.new(start, [start])] 
  visited = [start]

  until queue.empty?
    # Make the first BoardSquare in the queue the current BoardSquare
    current = queue.shift 

    # Find all possible moves for the current position that have not already been visited
    possible_moves = possible_moves(current.position).select { |move| !visited.include?(move) }
    
    # If the current position's possible moves includes the finishing position, add the finishing position
    # to the current path, display the amount of moves and the moves themselves, and return
    if possible_moves.include?(finish)
      current.path << finish
      if current.path.size-1 == 1
        puts "You made it in #{current.path.size-1} move! Here's your path:"
      else
        puts "You made it in #{current.path.size-1} moves! Here's your path"
      end
      current.path.each { |pos| p pos }
      return
    end
    
    # If the finishing position is not in the current possible moves list, 
    # add each possible move to the queue and create a new BoardSquare with
    # an updated path
    possible_moves.each do |move|
      queue << BoardSquare.new(move, (current.path + [move]))
      visited << move
    end

  end
end

# Create the possible moves for a given position on the board and remove
# invalid moves
def possible_moves(pos)
  changes = [[-2,-1],[-2,1],[-1,-2],[-1,2],[2,-1],[2,1],[1,-2],[1,2]]
  moves = []
  changes.each { |change| moves << [pos[0]+change[0], pos[1]+change[1]] }
  moves.select { |move| is_valid_position?(move) }
end

# Validate position would appear on an 8x8 Chess board
def is_valid_position?(pos)
  return (pos[0] > -1 && pos[0] < 8) && (pos[1] > -1 && pos[1] < 8) ? true : false
end

puts knight_moves([3,3],[4,3])

puts knight_moves([0,0],[7,7])
