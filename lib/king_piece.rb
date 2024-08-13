require './lib/chess_piece'
require './lib/rook_piece'

class KingPiece < ChessPiece
  def initialize(icon)
    super(icon)
    @moved = false
  end

  def match_move_pattern?(start, destination, space)
    if (destination.file - start.file).abs == 2 && start.rank == (white? ? 1 : 8)
      if @moved
        puts 'Invalid move. Cannot Castle since King has moved.'
      elsif space[(destination.file - start.file).negative? ? 0 : 7][white? ? 0 : 7].is_a?(RookPiece)
        return true unless space[(destination.file - start.file).negative? ? 0 : 7][white? ? 0 : 7].moved

        puts 'Invalid move. Cannot Castle since Rook has moved.'
      end
    elsif (destination.file - start.file).abs > 1 || (destination.rank - start.rank).abs > 1
      # puts 'Invalid move. King can move 1 space in any direction, or castle.'
    else
      return true
    end
    false
  end

  def update_state
    @moved = true
  end
end
