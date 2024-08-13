require './lib/chess_piece'
require './lib/empty'

class QueenPiece < ChessPiece
  def match_move_pattern?(start, destination, space)
    dx = (destination.file - start.file).negative? ? -1 : 1
    dy = (destination.rank - start.rank).negative? ? -1 : 1

    # if start.rank == destination.rank || start.file == destination.file || (destination.file - start.file).abs == (destination.rank - start.rank).abs
    #   for i in 1..((start.file == destination.file ? (destination.rank - start.rank) : (destination.file - start.file)).abs - 1)
    #     if space[start.file - 1 + (start.file == destination.file ? 0 : i * dx)][start.rank - 1 + (start.rank == destination.rank ? 0 : i * dy)] != EMPTY
    #       puts 'Invalid move. Piece in Queen\'s path.'
    #       return false
    #     end
    #   end
    #   true
    # end

    if start.rank == destination.rank
      # Handle horizontal move
      for i in 1..((destination.file - start.file).abs - 1)
        unless space[start.file - 1 + i * dx][start.rank - 1].is_a?(Empty)
          puts 'Invalid move. Piece in Queen\'s path.'
          return false
        end
      end
      true
    elsif start.file == destination.file
      # Handle vertical move
      for i in 1..((destination.rank - start.rank).abs - 1)
        unless space[start.file - 1][start.rank - 1 + i * dy].is_a?(Empty)
          puts 'Invalid move. Piece in Queen\'s path.'
          return false
        end
      end
      true
    elsif (destination.file - start.file).abs == (destination.rank - start.rank).abs
      # Handle diagonal move
      for i in 1..((destination.file - start.file).abs - 1)
        unless space[start.file - 1 + i * dx][start.rank - 1 + i * dy].is_a?(Empty)
          puts 'Invalid move. Piece in Queen\'s path.'
          return false
        end
      end
      true
    else
      puts 'Invalid move. Queen moves horizontally, vertically or diagonally.'
      false
    end
  end
end
