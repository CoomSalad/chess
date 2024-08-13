require_relative 'chess_board'
require_relative 'position'

class Chess
  WHITE = ChessBoard::WHITE

  def initialize
    @chess_board = ChessBoard.new
    @current_player = WHITE
  end

  def print_state
    puts @chess_board
    puts "#{@current_player} move:"
  end

  def rotate_player
    @current_player == WHITE ? BLACK : WHITE
    @chess_board.clear_en_vulnerability(@current_player)
  end

  def choose_move
    # accepts input:
    # position destination (e.g. b1 c3 -> move my piece on b1 to c3)
    # for castling, move your king 2 spaces towards your rook
    # for en passant, move your pawn as intended
    print_state
    loop do
      move = gets.chomp
      unless move.match(/[a-h][1-8] [a-h][1-8]/)
        puts 'Input syntax invalid. Enter again:'
        next
      end

      p move[0..1]
      p move[3..4]
      start = Position.new(move[0..1])
      destination = Position.new(move[3..4])
      if @chess_board.square(start).is_a?(String)
        puts "Invalid move. #{start} is empty."
      elsif start == destination
        puts 'Invalid move. Start and destination are the same.'
      elsif start.out_of_bound? || destination.out_of_bound?
        puts 'Invalid move. Position out of bound.'
      elsif @chess_board.square(start).white? != (@current_player == WHITE)
        puts "Invalid move. Piece on #{start} is not #{@current_player}."
      elsif !@chess_board.square(destination).is_a?(String) && @chess_board.square(destination).white? == (@current_player == WHITE)
        puts "Invalid move. Piece on #{destination} is #{@current_player}."
      elsif @chess_board.valid?(start, destination)
        # the move is valid
        puts 'move valid'
        @chess_board.move(start, destination)
        puts 'finished move'
        rotate_player
        puts 'finished turn'
        break
      end
      puts 'Enter move again:'
    end
  end

  def game_over?
    # if @current_player has no move
    false
  end

  def print_result
  end

  def play
    # loop gameplay until checkmate/stalemate:
    # Enter move
    # Check if move valid, re-enter if not
    # Perform move by updating game state accordingly
    # the other player move
    choose_move until game_over?
    print_result
  end
end
