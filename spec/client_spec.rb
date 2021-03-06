require "spec_helper"

describe ChessBoy::Client do
  describe "load_event_handlers!" do
    it "loads the routes from a yaml file" do
      discord_bot = Discordrb::Bot.new(token: "dummy", client_id: "dummy")
      lichess_client = double()
      event = double()

      users = YAML.load(File.read("config/users.yaml"))["users"]
      event_handlers = YAML.load(File.read("config/test_handlers.yaml"))
      time_stamp = Time.now

      expect(event).to receive(:public_send).with(:timestamp).and_return(time_stamp)
      expect(event).to receive(:respond).with("Pong")
      expect(discord_bot).to receive(:message).with(start_with: "!ping") do | &block |
        block.call(event)
      end

      client = ChessBoy::Client.new(
        discord_bot,
        lichess_client,
        event_handlers,
        users
      )

      expect(client).to receive(:public_send).with(:ping, time_stamp).and_return("Pong")

      client.load_event_handlers!
    end
  end

  describe "#initialize" do
    it "the logger defaults to STDOUT if nil" do
      users = YAML.load(File.read("config/users.yaml"))["users"]
      event_handlers = YAML.load(File.read("config/test_handlers.yaml"))

      stringio = StringIO.new
      STDOUT = stringio

      discord_bot = Discordrb::Bot.new(token: "dummy", client_id: "dummy")
      lichess_client = double()
      event = double()

      client = ChessBoy::Client.new(
        discord_bot,
        lichess_client,
        event_handlers,
        users
      )

      client.logger.info("hello world")

      expect(stringio.string).to match(/hello world/)
      expect(stringio.string).to match(/INFO/)
    end
  end
end
