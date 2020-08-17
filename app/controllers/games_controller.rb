require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @message = message(@word, @letters)
  end

  private 
  
  def included(attempt, grid)
    attempt.chars.all? { |char| attempt.count(char) <= grid.count(char) }
  end

  def english(word)
    answer = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(answer.read)
    json["found"]
  end

  def message(attempt, grid)
    if included(attempt.upcase, grid)
        if english(attempt)
          "Congratulations! #{attempt} is a valid English word!"
        else
          "Sorry but #{attempt} does not seem to be a valid English word."
        end
    else
        "Sorry but #{attempt} can't be built out of #{grid}"
    end
  end
end
