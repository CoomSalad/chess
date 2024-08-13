require './lib/chess_piece'
require './lib/empty'

class BishopPiece < ChessPiece
  def match_move_pattern?(start, destination, space)
    if (destination.file - start.file).abs != (destination.rank - start.rank).abs
      # puts 'Invalid move. Bishop moves in diagonal.'
    else
      dx = (destination.file - start.file).negative? ? -1 : 1
      dy = (destination.rank - start.rank).negative? ? -1 : 1
      for i in 1..((destination.file - start.file).abs - 1)
        unless space[start.file - 1 + i * dx][start.rank - 1 + i * dy].is_a?(Empty)
          # puts 'Invalid move. Piece in Bishop\'s path.'
          return false
        end
      end
      return true
    end
    false
  end
end
