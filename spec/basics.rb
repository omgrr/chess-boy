require "spec_helper"

describe ChessBoy::Basics do
  describe "#ping" do
    it "responds with Pong and the time it took" do
      boy = DummyBoy.new

      expect(boy.ping(Time.now-100)).to match(/Pong\! Responded in [0-9\.]+ seconds/)
    end
  end
end
