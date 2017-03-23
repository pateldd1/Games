SHIP_TYPES = {"Destroyer"=> 2,"Cruiser"=> 3,"Submarine" => 3, "Battleship" => 4,"Aircraft Carrier"=> 5}
class Board
  attr_accessor :grid, :all_ships, :direction, :ship_hash
  def initialize(grid = Board.default_grid)
    @grid = grid
    @all_ships = []
    @ship_hash = {}
    @direction = "none"
  end
  
  def sunken_ship_count
    @ship_hash.count {|ship_type,coords| self.sunk_ship?(ship_type)}
  end
  def self.default_grid
    Array.new(10){Array.new(10)}
  end
  
  def count
    self.grid.flatten.compact.length
  end
  
  def [](pos)
    row,col = pos
    self.grid[row][col]
  end
  
  def []=(pos,token)
    row,col = pos
    self.grid[row][col] = token
  end
  
  def empty?(position = self.grid)
    p position
    if position == self.grid
      return self.count == 0
    else
      return self[position] == nil
    end
  end
  
  def occupied?(position)
    self.offgrid?(position) || self[position] == :X
  end
    
  def occupied_all_around?(pos)
    row,col = pos
    [[row+1,col],[row-1,col],[row,col+1],[row,col-1]].all?{|position| self.occupied?(position)}
  end
  
  def offgrid?(pos)
    row,col = pos
    row < 0 || col < 0 || row > 9 || col > 9
  end
    
  def full?
    self.grid.flatten.none? {|val| val == nil}
  end
  
  def setup_display
    @all_ships.each do |ship|
        ship.each do |pos|
          self[pos]= :s
        end
    end
    puts "  0 1 2 3 4 5 6 7 8 9"
    self.grid.each_with_index do |row,inx|
      puts "#{inx} " + row.map {|val| if val == nil then " " else val end}.join(" ")
    end
  end
  
  def manual_populate_grid
    self.get_setup
    if !self.full?
      @ship_hash = (SHIP_TYPES.keys).zip(@all_ships).to_h
    else
      raise "Board is Full"
    end
  end
    
  def create_ship(origin,length,direction)
    row,col = origin
    ship = []
    case direction
      when "right"
        (col...col+length).each do |column|
          ship << [row,column]
        end
      when "left"
        (col-(length-1)..col).each do |column|
          ship << [row,column]
        end
      when "down"
        (row...row+length).each do |rowe|
          ship << [rowe,col]
        end
      when  "up"
        (row-(length-1)..row).each do |rowe|
          ship << [rowe,col]
        end
    end
    if ship.none?{|coord| self.offgrid?(coord)} && (ship&@all_ships.flatten(1)).empty? 
      @all_ships << ship.dup
    else
      raise "Ship is Improperly Placed, try again!"
    end
  end
    
  def get_setup
    origin = []
    directions = ["up","down","left","right"]
    input_direction = "none"
    SHIP_TYPES.each do |ship, length|
      self.setup_display
      begin
      puts "What coordinates (a,b) do you want the #{ship} of length #{length} to start at?"
      loop do
        origin = gets.chomp.scan(/\d+/).map(&:to_i)
        if origin.length == 2
          break
        else
          puts "Please Input Coordinates Again!"
        end
      end
      puts "What direction (up,down,left,right) do you want the ship to be placed?"
      loop do
        input_direction = gets.chomp
        if directions.include?(input_direction)
          break
        else
          puts "Please input one of the 4 directions!"
        end
      end
      create_ship(origin,length,input_direction)
      rescue
      retry
      end
    end
    self.setup_display
  end
  
  def place_ship(ship_size)
    pos = []
    ship = []
    vert=rand(0..1)
    pos << rand(ship.size...self.grid.length - ship_size)
    pos << rand(ship.size...self.grid[0].length - ship_size)
    until ship.size == ship_size
      if vert == 0
          ship << pos.dup
          pos[0] += 1
      else
          ship << pos.dup
          pos[1] += 1
      end
    end
  ship
  end

  def populate_grid
    if !self.full?
      addon =[]
        SHIP_TYPES.each_value do |size|
          loop do
            addon = place_ship(size).dup
            if (addon&@all_ships.flatten(1)).empty?
              @all_ships << addon.dup
              break
            end
          end
        end
      @all_ships.each do |ship|
        ship.each do |pos|
          self[pos]= :s
        end
      end
      @ship_hash = (SHIP_TYPES.keys).zip(@all_ships).to_h
    else
      raise "Board is Full"
    end
  end
  def sunk_ship?(ship_type)
    @ship_hash[ship_type].all? {|pos| self[pos] != :s}
  end
  def won?
    self.grid.flatten.none? {|val| val == :s}
  end
end

class HumanPlayer
  attr_accessor :name, :board, :hits, :attacks
  def initialize(name = "Human",board = Board.new)
    @name = name
    @board = board
    @hits = []
    @attacks = []
  end
  def get_play
    coordinates = nil
    puts "------------------------------------------"
    loop do 
      puts "What coordinates (a,b) do you want to attack?"
      coordinates = gets.chomp.scan(/\d+/).map(&:to_i)
      if coordinates.size == 2 && !self.board.occupied?(coordinates)
        break
      else
        puts "Please Try Again!"
      end
    end
      coordinates
  end
end

class ComputerPlayer
  attr_accessor :move_list,:name, :board, :hits, :attacks, :ai, :direction, :startpoint
    def initialize(name="Computer",board = Board.new)
      @name= name
      @board= board
      @hits = []
      @attacks = []
      @ai = false
      @direction = "none"
      @startpoint = []
      @move_list = (0..9).to_a.product((0..9).to_a).shuffle
    end
    
    def direct(position)
      next_position = []
      random_move = []
      row,col = position
      direction_switch_counter = 0
    if self.board.occupied_all_around?(position)
      random_move = @move_list[-1]
      @move_list.pop
      return random_move
    end
    until direction_switch_counter == 2
      case @direction
        when "down"
          next_position = [row+1,col]
        when "up"
          next_position = [row-1,col]
        when "right"
          next_position = [row,col+1]
        when "left"
          next_position = [row,col-1]
      end
        
      if self.board.occupied?(next_position)
        self.switch_directions
        row,col = @startpoint
        direction_switch_counter += 1
      else 
        break
      end
    end
      if direction_switch_counter == 2
        @ai = false
        @direction = "none"
        direction_switch_counter = 0
        random_move = @move_list[-1]
        @move_list.pop
        return random_move
      end
      if direction_switch_counter == 0 && self.board[next_position] != :s
        self.switch_directions
        @move_list.delete(next_position)
        return next_position
      else
        @move_list.delete(next_position)
        return next_position
      end
    end
    
    def switch_directions
      if @direction == "up"
        @direction = "down"
      elsif @direction == "down"
        @direction = "up"
      elsif @direction == "right"
        @direction = "left"
      elsif @direction == "left"
        @direction = "right"
      end
    end
      
    def get_play
      random_move = []
      return_value = nil
      if @ai == false && @hits[-1] == true && @direction == "none"
        @startpoint = @attacks[-1].dup
        @direction = "down"
        return_value = self.direct(@startpoint)
        @ai = true if self.board[return_value] == :s
        return return_value
      elsif @ai == false && @hits[-1] == false &&  @direction == "down"
        @direction = "up"
        return_value = self.direct(@startpoint)
        @ai = true if self.board[return_value] == :s
        return return_value
      elsif @ai == false && @hits[-1] == false && @direction == "up"
        @direction = "right"
        return_value = self.direct(@startpoint)
        @ai = true if self.board[return_value] == :s
        return return_value
      elsif @ai == false && @hits[-1] == false && @direction == "right"
        @direction = "left"
        return_value = self.direct(@startpoint)
        @ai = true if self.board[return_value] == :s
        return return_value
      elsif @ai == true && @hits[-1] == false
        return self.direct(@startpoint)
      elsif @ai == true && @hits[-1] == true
        return self.direct(@attacks[-1])
      else
        @ai = false
        @direction = "none"
        @startpoint = []
        random_move = @move_list[-1]
        @move_list.pop
        return random_move
      end
    end
end
      
class BattleshipGame
  attr_accessor :board, :player, :map, :setup
  
  def initialize(player_one = HumanPlayer.new,player_two = ComputerPlayer.new, setup = false)
    @player_one = player_one
    @player_two = player_two
    @current_player = player_one
    @turn = 0
    @setup = setup
  end
  
  def switch_players
    if @current_player == @player_one
      @current_player = @player_two
    else
      @current_player = @player_one
    end
  end
  
  def attack(pos)
    if @current_player.board[pos] == :s
      @current_player.hits << true
      puts "HIT!!"
      p pos
    else
      @current_player.hits << false
      puts "MISS!!"
      p pos
    end
    @current_player.attacks << pos
    @current_player.board[pos] = :X
  end
  def print_player_grid
    if @current_player == @player_one
      puts "-----------------------------------------"
      puts "PLAYER 1 GRID:"
      puts ""
    else
      puts "-----------------------------------------"
      puts "PLAYER 2 GRID:"
      puts ""
    end
  end
  def display_status
    self.print_player_grid
    puts "  0 1 2 3 4 5 6 7 8 9"
    @current_player.board.grid.each_with_index do |row,inx|
      puts "#{inx} " + row.map {|val| if val == :s || val == nil then " " else val end}.join(" ")
    end
    number_destroyed = @current_player.board.sunken_ship_count
    puts ""
    puts "Your opponent has #{5-number_destroyed} ships left"
  end
  def count
    @current_player.board.count
  end
    
  def game_over?
    @current_player.board.won?
  end
  
  def play_turn
    move = @current_player.get_play
    self.attack(move)
  end
  
  def play
    if @setup == false
      @player_one.board.populate_grid
      @player_two.board.populate_grid
    end
    if @setup == true && @player_two.is_a?(HumanPlayer)
      puts "SET UP YOUR SHIPS!"
      puts "PLAYER 1 GRID:"
      puts  "-----------------------------------------"
      @player_one.board.manual_populate_grid
      puts "SET UP YOUR SHIPS!"
      puts "PLAYER 2 GRID:"
      puts  "-----------------------------------------"
      @player_two.board.manual_populate_grid
      @player_one.board,@player_two.board = @player_two.board,@player_one.board
    elsif @setup == true && @player_two.is_a?(ComputerPlayer)
      puts "PLAYER 1 GRID:"
      puts  "-----------------------------------------"
      @player_one.board.populate_grid
      @player_two.board.manual_populate_grid
    end
    until @turn == 100 || self.game_over?
      self.display_status
      self.play_turn
      @turn += 1 if @current_player == @player_two
      self.display_status
      puts "#{100 - @turn} turns remaining"
      puts "Press Enter to Continue!"
      gets
      self.switch_players
    end
    if self.game_over? && @current_player == @player_one
    puts "Player 1 WINS!"
    elsif self.game_over? && @current_player == @player_two
    puts "Player 2 WINS!"
    else
    puts "NO ONE WINS!"
    end
  end
end

puts "Choose your opponent:"
puts "1: Computer"
puts "2: Human"
puts ""
input = 0
until (1..2).include?(input)
input = gets.chomp.to_i
end
puts "Manual Board Setup?(y/n)"
manual = 0
until manual == "y" || manual == "n"
  manual = gets.chomp
end
if input == 1 && manual == "n"
    game = BattleshipGame.new(HumanPlayer.new,ComputerPlayer.new)
elsif input == 1 && manual == "y"
    game = BattleshipGame.new(HumanPlayer.new,ComputerPlayer.new, true)
elsif input == 2 && manual == "n"
    game = BattleshipGame.new(HumanPlayer.new,HumanPlayer.new)
elsif input == 2 && manual == "y"
    game = BattleshipGame.new(HumanPlayer.new,HumanPlayer.new, true)
end

game.play

