require './lib/chess_piece'

class RookPiece < ChessPiece
  attr_reader :moved

  def initialize(icon)
    super(icon)
    @moved = false
  end

  def match_move_pattern?(start, destination, space)
    dx = (destination.file - start.file).negative? ? -1 : 1
    dy = (destination.rank - start.rank).negative? ? -1 : 1

    if start.rank == destination.rank
      # Handle horizontal move
      for i in 1..((destination.file - start.file).abs - 1)
        unless space[start.file - 1 + i * dx][start.rank - 1].is_a?(Empty)
          puts 'Invalid move. Piece in Rook\'s path.'
          return false
        end
      end
      true
    elsif start.file == destination.file
      # Handle vertical move
      for i in 1..((destination.rank - start.rank).abs - 1)
        unless space[start.file - 1][start.rank - 1 + i * dy].is_a?(Empty)
          puts 'Invalid move. Piece in Rook\'s path.'
          return false
        end
      end
      true
    else
      puts 'Invalid move. Rook moves horizontally or vertically.'
      false
    end
  end

  def update_state
    @moved = true
  end
end
