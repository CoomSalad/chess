require './lib/chess_piece'

class KnightPiece < ChessPiece
  def match_move_pattern?(start, destination, space)
    case [(destination.file - start.file).abs, (destination.rank - start.rank).abs]
    in [1, 2]|[2, 1]
      true
    end
    puts 'Invalid move. Knight moves in L - 2 space straight then 1 space sideway.'
    false
  end
end
