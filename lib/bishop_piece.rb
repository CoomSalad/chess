require './lib/chess_piece'

class BishopPiece < ChessPiece
  EMPTY = '□'

  def match_move_pattern?(start, destination, space)
    if (destination.file - start.file).abs != (destination.rank - start.rank).abs
      puts 'Invalid move. Bishop moves in diagonal.'
    else
      dx = (destination.file - start.file).negative? ? -1 : 1
      dy = (destination.rank - start.rank).negative? ? -1 : 1
      for i in 1..((destination.file - start.file).abs - 1)
        if space[start.file - 1 + i * dx][start.rank - 1 + i * dy] != EMPTY
          puts 'Invalid move. Piece in Bishop\'s path.'
          return false
        end
      end
      true
    end
    false
  end
end
