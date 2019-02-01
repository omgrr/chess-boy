$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require "chess_boy"
require "pry"

class DummyBoy
  include ChessBoy::Basics
  include ChessBoy::Stats

  def initialize
    @lichess_client = Lichess::Client.new(ENV["LICHESS_TOKEN"])
  end
end
