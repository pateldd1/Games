class Hangman
  attr_accessor :guesser, :referee, :board, :secret_word, :index_array
  def initialize(players = {})
    @guesser = players[:guesser]
    @referee = players[:referee]
    @board = []
    @secret_word = ""
    @index_array = []
  end
  
  def setup
    length = 0
    length = @referee.pick_secret_word
    @guesser.register_secret_length(length)
    @board = Array.new(length)
  end
  
  def take_turn
    current_guess = @guesser.guess(@board)
    index_array = @referee.check_guess(current_guess)
    self.update_board(index_array,current_guess)
    @guesser.handle_response(current_guess,index_array)
  end
  def board_full?
    @board.none? {|val| val == nil}
  end
  def play
    self.setup
    self.display_board
    puts "#{@guesser.name} has 8 attempts!!"
    attempt = 0
    until @guesser.candidate_words.length == 1 || attempt == 8 || self.board_full?
      attempt += 1
      puts "Attempt Number #{attempt}!!"
      self.take_turn
      self.display_board
      if @guesser.is_a?(HumanPlayer) && !self.board_full?
        puts "Do you want to guess the secret word??(y/n)"
        if gets.chomp == "y"
        puts "#{@guesser.name}, what do you think the secret word is??"
        @guesser.candidate_words << gets.chomp
        end
      end
      if @guesser.is_a?(ComputerPlayer) && @guesser.candidate_words.size == 0
        puts ""
        puts "#{@referee.name}, don't try to fool the computer. Your secret word does not exist!!"
        puts "YOU LOSE!!!"
        return
      end
    end
    
    if @guesser.is_a?(HumanPlayer) && @referee.is_a?(ComputerPlayer)
      if self.board_full?
        puts ""
        puts "#{@referee.name}'s secret word is #{@board.join}!!"
        puts "#{@guesser.name} WINS!!"
      elsif @guesser.candidate_words.length == 1 && @guesser.candidate_words.first == @referee.secret_word
        puts ""
        puts "#{@referee.name}'s secret word is #{@guesser.candidate_words.first}!!"
        puts "#{@guesser.name} WINS!"
      else
        puts ""
        puts "Nope, sorry #{@referee.name}'s secret word was #{@referee.secret_word}!!"
        puts "#{@guesser.name} LOSES!!"
      end
    elsif @guesser.is_a?(ComputerPlayer) && @referee.is_a?(HumanPlayer)
      if @guesser.candidate_words.length == 1 || self.board_full?
        puts ""
        puts "#{@guesser.name} guesses the word #{@guesser.candidate_words.first}!!"
        puts "#{@referee.name}, is this your secret word?(y/n)"
        if gets.chomp == "y"
          puts "#{@guesser.name} WINS!"
        else
          puts "#{@guesser.name} LOSES!"
        end
      else
        puts "The computer guesses #{@guesser.candidate_words.sample}!!"
        puts "Is this your word??(y/n) Be Honest!!"
        if gets.chomp == "y"
          puts "#{@guesser.name} WINS!!"
        else
          puts "#{@guesser.name} LOSES!!"
        end
      end
    elsif @guesser.is_a?(HumanPlayer) && @referee.is_a?(HumanPlayer)
      if self.board_full?
        puts ""
        puts "#{@referee.name}'s secret word is #{@board.join}!!"
        puts "#{@guesser.name} WINS!!"
      elsif @guesser.candidate_words.length == 1
        puts ""
        puts "#{@referee.name}, #{@guesser.name} guesses #{@guesser.candidate_words.first}. Is this your secret word?
        Now be Honest!!(y/n)"
        if gets.chomp == "y"
          puts "#{@guesser.name} WINS!!"
        else
          puts ""
          puts "Nope, sorry #{@referee.name}'s secret word was #{@referee.secret_word}!!"
          puts "#{@guesser.name} LOSES!!"
        end
      else
        puts ""
        puts "Nope, sorry #{@referee.name}'s secret word was #{@referee.secret_word}!!"
        puts "#{@guesser.name} LOSES!!"
      end
    end
  end    
  
  def display_board
    @board.each do |letter|
      if letter.is_a?(String)
        print "#{letter} "
      else
        print "_ "
      end
    end
    puts ""
  end
  def update_board(index_array,current_guess)
    if index_array.empty?
      return
    end
    index_array.each do |pos|
      @board[pos] = current_guess
    end
  end
end



class HumanPlayer
  attr_accessor :dictionary, :secret_word, :opponent_word_length, :candidate_words, :name
  def initialize
    @secret_word_length = 0
    @opponent_word_length = 0
    @candidate_words = []
    @used_indices = []
    @used_letters = []
    @name = name
  end
  
  def guess(board)
    puts "You have already guessed the letters #{@used_letters.sort}"
    puts "#{self.name}, please input a guess (a-z):"
    next_letter = gets.chomp
    until ("a".."z").include?(next_letter) && !board.include?(next_letter) && 
    !@used_letters.include?(next_letter)
      next_letter = gets.chomp
    end
    @used_letters << next_letter
    next_letter
  end
    
  def pick_secret_word
    puts "#{self.name}, what is the Length of your Secret Word?"
    length = gets.chomp.to_i
    until length.is_a?(Integer) && length > 0
      length = gets.chomp.to_i
    end
    @secret_word_length = length
    length
  end
  
  def check_guess(guess)
    puts "#{self.name}, where are the #{guess}'s in your word?"
    puts "Input a string of letter positions in the form a,b,c... or input none"
    indices = gets.chomp.scan(/\d+/).map(&:to_i)
    until indices.empty? || (indices.all?{|inx| inx <= @secret_word_length && inx > 0} && (@used_indices&indices).empty?)
      indices = gets.chomp.scan(/\d+/).map(&:to_i)
    end
    @used_indices += indices
    indices.map {|inx| inx - 1}
  end
    
  def register_secret_length(length)
    @opponent_word_length = length
    puts "Your Opponent's word length is #{length}"
  end
  
  def handle_response(letter,indices)
    puts "#{self.name}, the letter #{letter} occurs at #{indices.map{|inx| inx+1}}"
  end
end



class ComputerPlayer
  attr_accessor :dictionary, :secret_word, :opponent_word_length, :candidate_words, :name
  def initialize(dictionary = File.readlines("dictionary.txt").map(&:chomp))
    @opponent_word_length = 0
    @candidate_words = dictionary
    @secret_word = @candidate_words.sample
    @name = name
  end
  
  def guess(board)
    letter_counter = Hash.new(0)
    @candidate_words.each do |word|
      word.chars.each do |letter|
        letter_counter[letter] += 1
      end
    end
    letter_counter = letter_counter.sort_by {|k,v| v}
      answer = letter_counter.last.first
      until ("a".."z").include?(answer) && !board.include?(answer)
        letter_counter.pop
        answer = letter_counter.last.first
      end
      puts "#{self.name} guesses the letter #{answer}"
      answer
  end
  
  def pick_secret_word
    @secret_word.length
  end
  
  def check_guess(guess)
    secret_word_length = self.pick_secret_word
    (0...secret_word_length).find_all {|inx| @secret_word[inx] == guess}
  end
  
  def register_secret_length(length)
    @opponent_word_length = length
    @candidate_words.select!{|word| word.length == length}
  end
  
  def handle_response(letter,indices)
    array = []
    if indices.empty?
      @candidate_words.reject!{|word| word.include?(letter)}
    else
    @candidate_words.reject! {|word| word.chars.count(letter) != indices.count}
    @candidate_words = @candidate_words.map do |word| 
      if indices.all? {|inx| word[inx] == letter}
        word
      else
        nil
      end
    end.compact
    end
  end
end
puts "1: PLAYER1(human guesser) VS PLAYER2(computer referee)"
puts "2: PLAYER1(computer guesser) VS PLAYER2(human referee)"
puts "3: PLAYER1(human guesser) VS PLAYER2(human referee)"
input = gets.chomp.to_i
until (1..3).include?(input)
  input = gets.chomp.to_i
end
puts "What is Player 1's name??"
name_1 = gets.chomp
puts "What is Player 2's name??"
name_2 = gets.chomp
puts ""
case input
  when 1
    game = Hangman.new(guesser: HumanPlayer.new, referee: ComputerPlayer.new)
  when 2
    game = Hangman.new(guesser: ComputerPlayer.new, referee: HumanPlayer.new)
  when 
    game = Hangman.new(guesser: HumanPlayer.new, referee: HumanPlayer.new)
end
game.guesser.name = name_1
game.referee.name = name_2
game.play


