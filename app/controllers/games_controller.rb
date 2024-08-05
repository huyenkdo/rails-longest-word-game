require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (1..rand(5..15)).map { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters]
    @regexp = Regexp.new("[#{@letters.downcase}]+")
    @attempt = params[:word]
    @contains_letters_from_grid = -> { @attempt.match?(@regexp) }
    @letters_overused = lambda do
      grid_tallied = @letters.chars.tally
      attempt_tallied = @attempt.upcase.chars.tally
      result = []
      attempt_tallied.each_key do |key|
        grid_tallied[key].nil? || attempt_tallied[key] > grid_tallied[key] ? result << true : false
      end
      result.uniq.inspect.delete('[]') == 'true'
    end
    @english_word = lambda do
      url = "https://dictionary.lewagon.com/#{@attempt}"
      word_serialized = URI.open(url).read
      word = JSON.parse(word_serialized)
      word['found'] == true
    end
  end
end
