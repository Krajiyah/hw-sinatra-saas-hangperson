class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  attr_reader :word, :guesses, :wrong_guesses, :word_with_guesses

  def check_win_or_lose
    if @word_with_guesses == @word
      return :win
    elsif @wrong_guesses.length == 7
      return :lose
    end
    :play
  end

  def guess(letter)
    raise ArgumentError if letter == '' || letter == nil
    alpha_match = letter.match(/^[[:alpha:]]$/)
    raise ArgumentError unless alpha_match != nil && alpha_match.length > 0
    letter = letter.downcase
    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end
    i = -1
    indexes = []
    while i = @word.index(letter, i+1)
      indexes.push(i)
    end
    if indexes.length > 0
      @guesses += letter
      indexes.each do |i|
        if @word_with_guesses[i] == '-'
          @word_with_guesses[i] = letter
        end
      end
    else
      @wrong_guesses += letter
    end
    true
  end

  # Get a word from remote "random word" service
  def initialize()
    @word = "" # TODO
  end

  def initialize(word)
    @guesses = ""
    @wrong_guesses = ""
    @word_with_guesses = "-" * word.length
    @word = word
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
