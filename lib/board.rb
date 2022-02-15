class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @player1_name = name1
    @player2_name = name2
    @cups = Array.new(14) { Array.new }
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    @cups[0..5].each { |cup| 4.times {|n| cup << :stone}}
    @cups[7..12].each { |cup| 4.times {|n| cup << :stone}}
  end

  def valid_move?(start_pos)
    if !start_pos.between?(0,12) 
      raise "Invalid starting cup"
    end
    if @cups[start_pos].empty?
      raise "Starting cup is empty"
    end
    true
  end

  def make_move(start_pos, current_player_name)
    valid_move?(start_pos)
    stones_count = @cups[start_pos].count 
    @cups[start_pos].clear
    ending_idx = (start_pos+ stones_count) % 14
    ending_cup = @cups[ending_idx]
    start_pos += 1

    stones_count.times do |n|
      curr_pos = (start_pos + n) % 12
      curr_cup = @cups[curr_pos]
      if (start_pos - 1).between?(0,5) && curr_pos != 13 || (start_pos - 1).between?(7,12) && curr_pos != 7
        curr_cup << :stone 
      end
    end
    render
    next_turn(ending_idx)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    ending_cup = @cups[ending_cup_idx]
    return :switch if ending_cup.count == 1
    return ending_cup_idx if ending_cup.count > 1
    return :prompt if ending_cup_idx.between?(0,5) && ending_cup_idx != 13 || (ending_cup_idx - 1).between?(7,12) && ending_cup_idx != 7
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[0..5].all? { |cup| cup.empty?} ||
    @cups[7..12].all? { |cup| cup.empty?}
  end

  def winner
    case @cups[6] <=> @cups[13]
    when 1
      return @player1_name
    when 0
      return :draw 
    when -1
      return @player2_name
    end
  end
end
