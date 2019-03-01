$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require "yaml"
require "chess_boy"
require "pry"

class DummyBoy
  include ChessBoy::Basics
  include ChessBoy::Stats

  attr_reader :lichess_client, :event_handlers

  def initialize
    @lichess_client = Lichess::Client.new(ENV["LICHESS_TOKEN"])
    @users = ["bigswifty", "omgrr", "farnswurth"]
  end
end
