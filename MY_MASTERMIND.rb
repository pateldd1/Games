class Code
  attr_accessor :pegs
    PEGS = {Red: false, Green: false, Blue: false, Yellow: false, Orange: false, Purple: false}
    ALLOWED = ["r","g","b","y","o","p"]
    def initialize(pegs)
      @pegs = pegs
    end
  def self.parse(colors)
    colors = colors.downcase.chars
    return self.new(colors) unless colors.any?{|clr| !ALLOWED.include?(clr)} || colors.length != 4
    raise "Colors not allowed"
  end
    
    def self.random
      colors = (1..4).map {|clr| ALLOWED.shuffle.last}
      self.new(colors)
    end
    
    def [](inx)
      self.pegs[inx]
    end
    
    def exact_matches(realcode)
      count = 0
      self.pegs.each_with_index do |color,inx|
        if self.pegs[inx] == realcode.pegs[inx]
          count += 1
        end
      end
      count
    end
    
    def near_matches(guesscode)
    count = 0
    array =[]
      guesscode.pegs.each_with_index do |pg,inx|
        if self.pegs[inx] != guesscode.pegs[inx] && self.pegs.include?(pg) &&
          !array.include?(pg)
          count += 1
          array << pg
        end
      end
      count
    end
    
    def ==(code)
      if self.class == code.class && self.pegs == code.pegs 
      code = self
      end
    end
end

class Game
  attr_accessor :secret_code, :get_guess
  def initialize(code=Code.random)
    @secret_code = code
  end
  
  def play
    puts "Guess 4 colors from RGBYOP"
    turn = 1
    puts "Turn #{turn}: Guess:"
    guess = self.get_guess
    self.display_matches(guess)
    turn += 1
    until turn > 10 || guess == @secret_code
      puts "Turn #{turn}: Guess Again:"
      guess = self.get_guess
      self.display_matches(guess)
      turn += 1
    end
    if guess == @secret_code
      p "YOU WIN!"
    else
      p "YOU LOSE! The answer was #{@secret_code.pegs.join.upcase} by the way."
    end
  end
  
  def get_guess
    begin
      Code.parse(gets.chomp)
    rescue
      puts "Error, input again with rgboyp choices and 4 pegs!"
      retry
    end
  end
  
  def display_matches(guess)
    e = guess.exact_matches(@secret_code)
    n = guess.near_matches(@secret_code)
    p "#{e} exact matches"
    p "#{n} near matches"
  end
end

game = Game.new
game.play