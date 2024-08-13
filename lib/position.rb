class Position
  attr_reader :file, :rank

  # e.g. 'a1'
  def initialize(position)
    @file = position[0].ord - 'a'.ord + 1
    @rank = position[1].to_i
  end

  def at_rank_ends?
    @rank == 1 || @rank == 8
  end

  def mod(file_mod, rank_mod)
    Position.new("#{(@file + file_mod - 1).chr}#{@rank + rank_mod}")
  end

  def ==(other)
    @file == other.file && @rank == other.rank
  end

  def out_of_bound?
    @file < 1 || @file > 8 || @rank < 1 || @rank > 8
  end

  def to_s
    "#{(@file + 'a'.ord - 1).chr}#{@rank}"
  end
end
