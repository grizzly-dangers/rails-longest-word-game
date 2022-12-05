require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split(" ")
    if !possible_word?(@letters, @word)
      @score = "Sorry but #{@word.upcase} can't be built out of #{@letters.join(', ')}"
    elsif !valid_word?(@word)
      @score = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
    else
      @score = "Congratulations! #{@word.upcase} is a valid English word!"
    end
  end

  def possible_word?(grid, word)
    available_letters = grid
    p available_letters, word
    word.split('').each do |letter|
      if available_letters.include?(letter)
        available_letters.delete_at(available_letters.index(letter))
      else
        return false
      end
    end
    true
  end

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_1 = URI.open(url).read
    JSON.parse(word_1)
  end
end
