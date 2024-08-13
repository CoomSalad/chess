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
    puts "in Pawn matching move with start:#{start} destination:#{destination}"
    if destination.rank == start.rank + 2 && start.file == destination.file
      # handles first move 2 spaces
      # handles en passant
      if space[destination.file - 1][destination.rank - 1].is_a?(Empty) && space[destination.file - 1][destination.rank - 2].is_a?(Empty)
        if @moved
          puts 'Invalid move. Pawn can move forward 2 spaces only on first move.'
        else
          @en_vulnerable = true
          true
        end
      else
        puts 'Invalid move. Piece in Pawn\'s path.'
      end
    elsif destination.rank == start.rank + 1 && (destination.file - start.file).abs == 1
      # handles capture
      if space[destination.file - 1][destination.rank - 1].white? != white?
        return true
      elsif space[destination.file - 1][destination.rank - 2].is_a(PawnPiece) && space[destination.file - 1][destination.rank - 2].en_vulnerable
        en_passant(destination, space)
        true
      else
        puts 'Invalid move. Pawn needs target to capture diagonally.'
      end
    elsif destination.rank - start.rank == 1 && start.file == destination.file
      # handles move 1 space
      puts 'handling pawn move 1 space'
      return true if space[destination.file - 1][destination.rank - 1].is_a?(Empty)

      puts 'Invalid move. Piece in Pawn\'s path.'

    else
      puts 'Invalid move. Pawn can move forward 1 space, 2 spaces on first move, or capture diagonally.'
    end
    false
  end

  def clear_vulnerability
    @en_vulnerable = false
  end

  def en_passant(destination, space)
    space[destination.file - 1][destination.rank - 2] = Empty.new(EMPTY)
  end

  def update_state
    @moved = true
  end
end
