module ChessBoy
  class Client
    include ChessBoy::Basics
    include ChessBoy::Stats

    attr_reader :discord_bot, :lichess_client, :event_handlers

    def initialize(discord_bot, lichess_client, event_handlers, users, discord_mappings = nil)
      @discord_bot = discord_bot
      @lichess_client = Lichess::Client.new(ENV["LICHESS_TOKEN"])
      @event_handlers = event_handlers
      @users = users
      @discord_mappings = discord_mappings
    end

    def load_event_handlers!
      puts "Loading event handlers"
      @event_handlers.each do |event_name, event|
        filter = {}
        filter[event["filter_type"].to_sym] = "!#{event["filter_word"]}"
        puts "#{event_name} #{event}"

        @discord_bot.message(filter) do |discord_event|
          value = discord_event.public_send(event["args"].to_sym)
          message = self.public_send(event["route"].to_sym, value)
          discord_event.respond(message)
        end
      end
    end

    def run
      @discord_bot.run
    end
  end
end
