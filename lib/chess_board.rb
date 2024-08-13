require_relative 'king_piece'
require_relative 'queen_piece'
require_relative 'rook_piece'
require_relative 'bishop_piece'
require_relative 'knight_piece'
require_relative 'pawn_piece'
require_relative 'empty'
require_relative 'position'

class ChessBoard
  attr_accessor :space

  RANKS = 8
  FILES = 8
  WHITE = 'White'
  BLACK = 'Black'
  WHITE_KING = '♔'
  WHITE_QUEEN = '♕'
  WHITE_ROOK = '♖'
  WHITE_BISHOP = '♗'
  WHITE_KNIGHT = '♘'
  WHITE_PAWN = '♙'
  BLACK_KING = '♚'
  BLACK_QUEEN = '♛'
  BLACK_ROOK = '♜'
  BLACK_BISHOP = '♝'
  BLACK_KNIGHT = '♞'
  BLACK_PAWN = '♟︎'
  EMPTY = '□'

  def initialize
    setup
  end

  def setup
    @space = [
      [RookPiece.new(WHITE_ROOK),
       PawnPiece.new(WHITE_PAWN)] + Array.new(4,
                                              Empty.new(EMPTY)) + [PawnPiece.new(BLACK_PAWN),
                                                                   RookPiece.new(BLACK_ROOK)],
      [KnightPiece.new(WHITE_KNIGHT),
       PawnPiece.new(WHITE_PAWN)] + Array.new(4,
                                              Empty.new(EMPTY)) + [PawnPiece.new(BLACK_PAWN),
                                                                   KnightPiece.new(BLACK_KNIGHT)],
      [BishopPiece.new(WHITE_BISHOP),
       PawnPiece.new(WHITE_PAWN)] + Array.new(4,
                                              Empty.new(EMPTY)) + [PawnPiece.new(BLACK_PAWN),
                                                                   BishopPiece.new(BLACK_BISHOP)],
      [QueenPiece.new(WHITE_QUEEN),
       PawnPiece.new(WHITE_PAWN)] + Array.new(4,
                                              Empty.new(EMPTY)) + [PawnPiece.new(BLACK_PAWN),
                                                                   QueenPiece.new(BLACK_QUEEN)],
      [KingPiece.new(WHITE_KING),
       PawnPiece.new(WHITE_PAWN)] + Array.new(4,
                                              Empty.new(EMPTY)) + [PawnPiece.new(BLACK_PAWN),
                                                                   KingPiece.new(BLACK_KING)],
      [BishopPiece.new(WHITE_BISHOP),
       PawnPiece.new(WHITE_PAWN)] + Array.new(4,
                                              Empty.new(EMPTY)) + [PawnPiece.new(BLACK_PAWN),
                                                                   BishopPiece.new(BLACK_BISHOP)],
      [KnightPiece.new(WHITE_KNIGHT),
       PawnPiece.new(WHITE_PAWN)] + Array.new(4,
                                              Empty.new(EMPTY)) + [PawnPiece.new(BLACK_PAWN),
                                                                   KnightPiece.new(BLACK_KNIGHT)],
      [RookPiece.new(WHITE_ROOK),
       PawnPiece.new(WHITE_PAWN)] + Array.new(4,
                                              Empty.new(EMPTY)) + [PawnPiece.new(BLACK_PAWN), RookPiece.new(BLACK_ROOK)]
    ]
  end

  # takes a Position and return the piece in corresponding square
  def square(position)
    p @space[position.file - 1][position.rank - 1]
    puts
    @space[position.file - 1][position.rank - 1]
  end

  def position(file, rank)
    Position.new("#{(file + 'a'.ord).chr}#{rank + 1}")
  end

  def king_position(side)
    king = side == WHITE ? WHITE_KING : BLACK_KING
    for i in 0..FILES
      for j in 0..RANKS
        return position(i, j) if @space[i][j].icon == king
      end
    end
  end

  def same_side?(piece_a, piece_b)
    piece_a.white? == piece_b.white?
  end

  def is_side?(piece, side)
    side == WHITE ? piece.white? : !piece.white?
  end

  def king_in_check?(side)
    @space.each_with_index do |file, file_index|
      file.each_with_index do |piece, rank_index|
        # Check if non-EMPTY, opposing piece puts King in check
        next if piece.is_a?(Empty) || is_side?(piece, side)

        next unless piece.match_move_pattern?(position(file_index, rank_index), king_position(side), @space)

        return true
      end
    end
    false
  end

  def put_king_in_check?(start, destination)
    side = square(start).white? ? WHITE : BLACK
    start_backup = square(start)
    destination_backup = square(destination)
    castling = is_castling?(start, destination)

    if castling
      castle(start, destination)
    else
      move_piece(start, destination)
    end

    result = king_in_check?(side)
    # revert change
    if castling
      king_to_left = (destination.file - start.file).negative?
      rook = @space[king_to_left ? 3 : 5][0]
      @space[king_to_left ? 3 : 5][0] = Empty.new(EMPTY)
      @space[king_to_left ? 0 : 7][side == WHITE ? 0 : 7] = rook
    end
    @space[destination.file - 1][destination.rank - 1] = destination_backup
    @space[start.file - 1][start.rank(-1)] = start_backup
    result
  end

  def valid?(start, destination)
    puts 'in chess_board.valid?'
    # First check if piece could make such move
    if square(start).match_move_pattern?(start, destination, @space)
      puts 'move pattern matched'
      # Then check if it puts King in check
      if put_king_in_check?(start, destination)
        puts 'The move would put your King in check.'
      else
        true
      end
    end
    puts 'move pattern not matched'
    false
  end

  def is_castling?(start, destination)
    square(start).is_a?(KingPiece) && (destination.file - start.file).abs == 2
  end

  def move(start, destination)
    if is_castling?(start, destination)
      castle(start, destination)
    else
      move_piece(start, destination)
    end
    # Handle Pawn Promotion
    if destination.at_rank_ends? && @space[destination.file - 1][destination.rank - 1].is_a?(PawnPiece)
      promote_pawn(destination)
    end
    # The moved piece updates its state, e.g. King, Rook, Pawn keeps track of their first move
    @space[destination.file - 1][destination.rank - 1].update_state
  end

  def move_piece(start, destination)
    @space[destination.file - 1][destination.rank - 1] = square(start)
    @space[start.file - 1][start.rank - 1] = Empty.new(EMPTY)
  end

  def castle(start, destination)
    move_piece(start, destination)
    king_to_left = (destination.file - start.file).negative?
    move_piece(Position.new("#{king_to_left ? 'a' : 'h'}#{square(start).white? ? 1 : 8}"),
               destination.mod(king_to_left ? 1 : -1, 0))
  end

  def new_piece(type, side)
    case type
    when 'q'
      QueenPiece.new(side == WHITE ? WHITE_QUEEN : BLACK_QUEEN)
    when 'r'
      RookPiece.new(side == WHITE ? WHITE_ROOK : BLACK_ROOK)
    when 'b'
      BishopPiece.new(side == WHITE ? WHITE_BISHOP : BLACK_BISHOP)
    when 'n'
      KnightPiece.new(side == WHITE ? WHITE_KNIGHT : BLACK_KNIGHT)
    else
      puts 'Error: new_piece erroneous match'
      QueenPiece.new(side == WHITE ? WHITE_QUEEN : BLACK_QUEEN)
    end
  end

  def promote_pawn(position)
    side = square(position).white? ? WHITE : BLACK
    puts "Pawn promotion on #{position} to (q)ueen, (r)ook, (b)ishop, or k(n)ight:"
    loop do
      promote_to = gets.chomp.downcase
      if promote_to.match(/[q,r,b,n]/)
        @space[position.file - 1][position.rank - 1] = new_piece(promote_to, side)
        return
      end
      puts 'Invalid choice. Choose (q)ueen, (r)ook, (b)ishop, or k(n)ight:'
    end
  end

  def clear_en_vulnerability(side)
    @space.each do |file|
      file.each do |piece|
        piece.clear_vulnerability if is_side?(piece, side) && piece.is_a?(PawnPiece)
      end
    end
  end

  def to_s
    str = ''
    for i in 0..RANKS - 1
      @space.each do |file|
        str += file[RANKS - 1 - i].to_s
      end
      str += "\n"
    end
    str
  end
end
