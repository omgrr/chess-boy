require "spec_helper"

describe ChessBoy::Stats do
  describe "#stats" do
    it "responds with the stats for everything" do
      boy = DummyBoy.new

      stats_message = boy.stats("!stats omgrr")

      expect(stats_message).to match(/\sblitz\s+|\s?\d{4}/)
      expect(stats_message).to match(/\sbullet\s+|\s?\d{4}/)
      expect(stats_message).to match(/\scorrespondence\s+|\s?\d{4}/)
      expect(stats_message).to match(/\spuzzle\s+|\s?\d{4}/)
      expect(stats_message).to match(/\sclassical\s+|\s?\d{4}/)
      expect(stats_message).to match(/\srapid\s+|\s?\d{4}/)
    end

    it "encapsulates everything in backticks" do
      boy = DummyBoy.new

      stats_message = boy.stats("!stats omgrr")

      expect(stats_message).to match(/^```/)
      expect(stats_message).to match(/```$/)
    end

    it "responds with a specific stype of stats" do
      boy = DummyBoy.new

      stats_message = boy.stats("!stats omgrr blitz")

      expect(stats_message).to match(/\sblitz\s+|\s?\d{4}/)
      expect(stats_message).to_not match(/bullet|rapid|puzzle/)
    end

    it "errors when the requested stat type doesn't exist" do
      boy = DummyBoy.new

      stats_message = boy.stats("!stats omgrr foobar")

      expect(stats_message).to eq("Don't know of any type foobar")
    end

    it "errors when a user doesn't exist" do
      boy = DummyBoy.new
      user = "foorbar".hash

      stats_message = boy.stats("!stats #{user}")

      expect(stats_message).to eq("The user #{user} does not exist")
    end
  end
end
