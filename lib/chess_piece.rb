class ChessPiece
  attr_reader :icon

  BLACK_KING = '♚'

  def initialize(icon)
    @icon = icon
  end

  def update_state
  end

  # returns if a move is valid
  def match_move_pattern?(start, destination, space)
    puts 'You should not see this. match_move_pattern? not implemented.'
    false
  end

  def white?
    @icon < BLACK_KING
  end

  def to_s
    @icon
  end
end
