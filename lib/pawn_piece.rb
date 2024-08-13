require './lib/chess_piece'
require './lib/empty'

class PawnPiece < ChessPiece
  attr_reader :moved
  attr_accessor :en_vulnerable

  def initialize(icon)
    super(icon)
    @moved = false
    @en_vulnerable = false
  end

  def match_move_pattern?(start, destination, space)
    dy = white? ? 1 : -1
    if destination.rank == start.rank + 2 * dy && start.file == destination.file
      # handles first move 2 spaces
      # handles en passant
      if space[destination.file - 1][destination.rank - 1].is_a?(Empty) && space[destination.file - 1][destination.rank - 1 - dy].is_a?(Empty)
        if @moved
          puts 'Invalid move. Pawn can move forward 2 spaces only on first move.'
        else
          @en_vulnerable = true
          return true
        end
      else
        puts 'Invalid move. Piece in Pawn\'s path.'
      end
    elsif destination.rank == start.rank + dy && (destination.file - start.file).abs == 1
      # handles capture
      if !space[destination.file - 1][destination.rank - 1].is_a?(Empty) && space[destination.file - 1][destination.rank - 1].white? != white?
        return true
      elsif space[destination.file - 1][destination.rank - 1 - dy].is_a?(PawnPiece) && space[destination.file - 1][destination.rank - 1 - dy].en_vulnerable
        en_passant(destination, space, dy)
        return true
      else
        # puts 'Invalid move. Pawn needs target to capture diagonally.'
      end
    elsif destination.rank - start.rank == dy && start.file == destination.file
      # handles move 1 space
      return true if space[destination.file - 1][destination.rank - 1].is_a?(Empty)

      # puts 'Invalid move. Piece in Pawn\'s path.'

    else
      # puts 'Invalid move. Pawn can move forward 1 space, 2 spaces on first move, or capture diagonally.'
    end
    false
  end

  def clear_vulnerability
    @en_vulnerable = false
  end

  def en_passant(destination, space, dy)
    puts "en passant: #{destination.file - 1}#{destination.rank - 1 - dy}"
    space[destination.file - 1][destination.rank - 1 - dy] = Empty.new
  end

  def update_state
    @moved = true
  end
end
