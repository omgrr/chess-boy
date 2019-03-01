$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require "yaml"
require "dotenv"
require "chess_boy"
require "pry"

class DummyBoy
  include ChessBoy::Basics
  include ChessBoy::Stats

  attr_reader :lichess_client, :event_handlers, :discord_bot

  def initialize
    Dotenv.load("discord.env")

    @lichess_client = Lichess::Client.new(ENV["LICHESS_TOKEN"])
    @users = ["bigswifty", "omgrr", "farnswurth"]
    @discord_mappings = {
      "@farnsworth" => "farnsworth"
    }
    @discord_bot = Discordrb::Bot.new(
      token: ENV["DISCORD_TOKEN"],
      client_id: ENV["DISCORD_CLIENT_ID"],
    )
  end

  def run_discord_bot
    @discord_bot.run(:async)
  end
end
