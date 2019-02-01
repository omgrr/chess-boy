module ChessBoy
  class Client
    include ChessBoy::Basics
    include ChessBoy::Stats

    def initialize(discord_bot, lichess_client)
      @discord_bot = discord_bot
      @lichess_client = Lichess::Client.new(ENV["LICHESS_TOKEN"])
    end

    def run
      @discord_bot.message(with_text: "!Ping") do |event|
        message = ping(event.timestamp)
        event.respond(message)
      end

      @discord_bot.message(start_with: "!stats") do |event|
        message = stats(event.message.content)
        event.respond(message)
      end

      @discord_bot.run
    end
  end
end
