class Board
  attr_accessor :grid
  def initialize(grid=[[nil,nil,nil],[nil,nil,nil],[nil,nil,nil]])
    @grid = grid
  end
  def place_mark(pos,mark)
    row,col = pos
    @grid[row][col]= mark
  end
  def empty?(pos)
    row,col = pos
    @grid[row][col] == nil
  end
  def x_diagonals?
    (@grid[0][0] == :X && @grid[1][1] == :X && @grid[2][2] == :X) || 
    (@grid[0][2] == :X && @grid[1][1] == :X && @grid[2][0] == :X)
  end
  def o_diagonals?
 (@grid[0][0] == :O && @grid[1][1] == :O && @grid[2][2] == :O) || 
    (@grid[0][2] == :O && @grid[1][1] == :O && @grid[2][0] == :O)
  end
  def winner
    if @grid.any? {|row| row.all? {|mark| mark == :X}} ||
    @grid.transpose.any? {|column| column.all? {|mark| mark == :X }} ||
    x_diagonals?
      puts "Human Wins!"
      return :X
    elsif @grid.any? {|row| row.all? {|mark| mark == :O}} ||
    @grid.transpose.any? {|column| column.all? {|mark| mark == :O }} ||
    o_diagonals?
      puts "Computer Wins"
      return :O
    else
      return nil
    end
  end
  def over?
    self.winner == :X || self.winner == :O || !@grid.flatten.include?(nil)
  end
    
end

class ComputerPlayer
  attr_accessor :name, :board, :mark
  def initialize(name)
    @name = name
    @board = board
    @mark = mark
  end
  
  def display(game)
    self.board = game.board
  end
  def opposite_mark
    if self.mark == :X
      return :O
    else
      return :X
    end
  end
  def get_move
    map = self.board.grid
    if map[0][0] == self.mark && map[1][0] == self.mark && self.board.empty?([2,0])
      return [2,0]
    elsif map[1][0] == self.mark && map[2][0] == self.mark && self.board.empty?([0,0])
      return [0,0]
    elsif map[0][0] == self.mark && map[2][0] == self.mark && self.board.empty?([1,0])
      return [1,0]
    elsif map[0][1] == self.mark && map[1][1] == self.mark && self.board.empty?([2,1])
      return [2,1]
    elsif map[1][1] == self.mark && map[2][1] == self.mark && self.board.empty?([0,1])
      return [0,1]
    elsif map[0][1] == self.mark && map[2][1] == self.mark && self.board.empty?([1,1])
      return [1,1]
    elsif map[0][2] == self.mark && map[1][2] == self.mark && self.board.empty?([2,2])
      return [2,2]
    elsif map[1][2] == self.mark && map[2][2] == self.mark && self.board.empty?([0,2])
      return [0,2]
    elsif map[0][2] == self.mark && map[2][2] == self.mark && self.board.empty?([1,2])
      return [1,2]
      
    elsif map[0][0] == self.mark && map[0][1] == self.mark && self.board.empty?([0,2])
      return [0,2]
    elsif map[0][0] == self.mark && map[0][2] == self.mark && self.board.empty?([0,1])
      return [0,1]
    elsif map[0][1] == self.mark && map[0][2] == self.mark && self.board.empty?([0,0])
      return [0,0]
    elsif map[1][0] == self.mark && map[1][1] == self.mark && self.board.empty?([1,2])
      return [1,2]
    elsif map[1][0] == self.mark && map[1][2] == self.mark && self.board.empty?([1,1])
      return [1,1]
    elsif map[1][1] == self.mark && map[1][2] == self.mark && self.board.empty?([1,0])
      return [1,0]
    elsif map[2][0] == self.mark && map[2][1] == self.mark && self.board.empty?([2,2])
      return [2,2]
    elsif map[2][0] == self.mark && map[2][2] == self.mark && self.board.empty?([2,1])
      return [2,1]
    elsif map[2][1] == self.mark && map[2][2] == self.mark && self.board.empty?([2,0])
      return [2,0]
      
    elsif map[0][0] == self.mark && map[1][1] == self.mark && self.board.empty?([2,2])
      return [2,2]
    elsif map[1][1] == self.mark && map[2][2] == self.mark && self.board.empty?([0,0])
      return [0,0]
    elsif map[0][0] == self.mark && map[2][2] == self.mark && self.board.empty?([1,1])
      return [1,1]
    elsif map[0][2] == self.mark && map[1][1] == self.mark && self.board.empty?([2,0])
      return [2,0]
    elsif map[1][1] == self.mark && map[2][0] == self.mark && self.board.empty?([0,2])
      return [0,2]
    elsif map[2][0] == self.mark && map[0][2] == self.mark && self.board.empty?([1,1])
      return [1,1]
      
    elsif map[0][0] == self.opposite_mark && map[1][0] == self.opposite_mark && self.board.empty?([2,0])
      return [2,0]
    elsif map[1][0] == self.opposite_mark && map[2][0] == self.opposite_mark && self.board.empty?([0,0])
      return [0,0]
    elsif map[0][0] == self.opposite_mark && map[2][0] == self.opposite_mark && self.board.empty?([1,0])
      return [1,0]
    elsif map[0][1] == self.opposite_mark && map[1][1] == self.opposite_mark && self.board.empty?([2,1])
      return [2,1]
    elsif map[1][1] == self.opposite_mark && map[2][1] == self.opposite_mark && self.board.empty?([0,1])
      return [0,1]
    elsif map[0][1] == self.opposite_mark && map[2][1] == self.opposite_mark && self.board.empty?([1,1])
      return [1,1]
    elsif map[0][2] == self.opposite_mark && map[1][2] == self.opposite_mark && self.board.empty?([2,2])
      return [2,2]
    elsif map[1][2] == self.opposite_mark && map[2][2] == self.opposite_mark && self.board.empty?([0,2])
      return [0,2]
    elsif map[0][2] == self.opposite_mark && map[2][2] == self.opposite_mark && self.board.empty?([1,2])
      return [1,2]
      
    elsif map[0][0] == self.opposite_mark && map[0][1] == self.opposite_mark && self.board.empty?([0,2])
      return [0,2]
    elsif map[0][0] == self.opposite_mark && map[0][2] == self.opposite_mark && self.board.empty?([0,1])
      return [0,1]
    elsif map[0][1] == self.opposite_mark && map[0][2] == self.opposite_mark && self.board.empty?([0,0])
      return [0,0]
    elsif map[1][0] == self.opposite_mark && map[1][1] == self.opposite_mark && self.board.empty?([1,2])
      return [1,2]
    elsif map[1][0] == self.opposite_mark && map[1][2] == self.opposite_mark && self.board.empty?([1,1])
      return [1,1]
    elsif map[1][1] == self.opposite_mark && map[1][2] == self.opposite_mark && self.board.empty?([1,0])
      return [1,0]
    elsif map[2][0] == self.opposite_mark && map[2][1] == self.opposite_mark && self.board.empty?([2,2])
      return [2,2]
    elsif map[2][0] == self.opposite_mark && map[2][2] == self.opposite_mark && self.board.empty?([2,1])
      return [2,1]
    elsif map[2][1] == self.opposite_mark && map[2][2] == self.opposite_mark && self.board.empty?([2,0])
      return [2,0]
      
    elsif map[0][0] == self.opposite_mark && map[1][1] == self.opposite_mark && self.board.empty?([2,2])
      return [2,2]
    elsif map[1][1] == self.opposite_mark && map[2][2] == self.opposite_mark && self.board.empty?([0,0])
      return [0,0]
    elsif map[0][0] == self.opposite_mark && map[2][2] == self.opposite_mark && self.board.empty?([1,1])
      return [1,1]
    elsif map[0][2] == self.opposite_mark && map[1][1] == self.opposite_mark && self.board.empty?([2,0])
      return [2,0]
    elsif map[1][1] == self.opposite_mark && map[2][0] == self.opposite_mark && self.board.empty?([0,2])
      return [0,2]
    elsif map[2][0] == self.opposite_mark && map[0][2] ==self.opposite_mark && self.board.empty?([1,1])
      return [1,1]  
    else
      loop do
        a = rand(0..2)
        b = rand(0..2)
      comps_move = [a,b] 
        if self.board.empty?(comps_move)
          return comps_move
        end
      end
    end
  end
end
class HumanPlayer
  attr_accessor :name, :mark, :board
  def initialize(name)
    @name = name
    @mark = mark
    @board = board
  end
  
  def create(game)
    self.board = game.board
  end
  
  def get_move
    loop do
    puts "where do you want to move?"
    input = gets.chomp.to_i
    case input
      when 1
      to = [0,0]
      when 2
      to = [0,1]
      when 3
      to = [0,2]
      when 4
      to = [1,0]
      when 5
      to = [1,1]
      when 6
      to = [1,2]
      when 7
      to = [2,0]
      when 8
      to = [2,1]
      when 9
      to = [2,2]
      else
      next
    end
      if valid_move?(to) 
        return to 
      end
    puts "Invalid move!"
    end
  end
  
  def valid_move?(move)
    (0..2).include?(move[0]) && (0..2).include?(move[1]) && self.board.empty?(move)
  end
  
  def display(board)
    puts "-------------------"
    counter = 0
    board.grid.each do |row| 
        puts "|  #{row[0]||counter+1}  |  #{row[1]||counter+2}  |  #{row[2]||counter+3}  |"
        puts "-------------------"
        counter += 3
    end
  end

  
end
class Game
  attr_accessor :player_one, :player_two, :board, :current_player
  def initialize(player_one,player_two)
    @player_one = player_one
    @player_two = player_two
    @board = Board.new
    @current_player = player_one
  end
  
  def switch_players!
    if @current_player == @player_one
      @current_player = @player_two
    else
      @current_player = @player_one
    end
  end
  
  def tie_game
    puts "Its a TIE"
  end
  def play_turn
    where_to_go = @current_player.get_move
    self.board.place_mark(where_to_go,@current_player.mark)
    self.switch_players!
  end
  def play
    until self.board.over?
      @player_one.display(self.board) if @current_player == @player_one
      play_turn
    end
    @player_one.display(self.board)
    self.board.winner || self.tie_game
  end
end

player_one = HumanPlayer.new("dave")
player_one.mark = :X
player_two = ComputerPlayer.new("gizmo")

player_two.mark = :O
tic_tac_toe = Game.new(player_one,player_two)
player_one.create(tic_tac_toe)
player_two.display(tic_tac_toe)
tic_tac_toe.play