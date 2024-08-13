require './lib/chess_piece'

class Empty < ChessPiece
  def match_move_pattern?(start, destination, space)
    puts 'You should not see this. match_move_pattern? not implemented.'
    false
  end

  def white?
    puts 'You should not see this. Empty.white?'
    false
  end

  def to_s
    @icon
  end
end
