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

    it "can use the discord mapping for getting a user's stats" do
      boy = DummyBoy.new
      boy.run_discord_bot

      stats_message = boy.stats("!stats <@199424442017775619>")

      expect(stats_message).to_not be_nil
      expect(stats_message).to match(/\sblitz\s+|\s?\d{4}/)
      expect(stats_message).to match(/\sbullet\s+|\s?\d{4}/)
      expect(stats_message).to match(/\scorrespondence\s+|\s?\d{4}/)
      expect(stats_message).to match(/\spuzzle\s+|\s?\d{4}/)
      expect(stats_message).to match(/\sclassical\s+|\s?\d{4}/)
      expect(stats_message).to match(/\srapid\s+|\s?\d{4}/)
    end
  end

  describe "#rank" do
    it "ranks everyone for the given stat" do
      boy = DummyBoy.new

      rank_message = boy.rank("!rank blitz")
      expect(rank_message).to include("omgrr")
      expect(rank_message).to include("bigswifty")
      expect(rank_message).to include("farnswurth")
    end

    it "sorts the rankings by the given stat" do
      boy = DummyBoy.new

      expect(boy.lichess_client.users).to receive("get").with("omgrr").and_return(
        {"id" => "omgrr", "perfs" => {"blitz" => {"games"=>1, "rating"=> 3, "prog"=>-34} } }
      )

      expect(boy.lichess_client.users).to receive("get").with("bigswifty").and_return(
        {"id" => "bigswifty", "perfs" => {"blitz" => {"games"=>1, "rating"=> 2, "prog"=>-34} } }
      )

      expect(boy.lichess_client.users).to receive("get").with("farnswurth").and_return(
        {"id" => "farnswurth", "perfs" => {"blitz" => {"games"=>1, "rating"=> 1, "prog"=>-34} } }
      )

      rank_message = boy.rank("!rank blitz")

      rank_lines = rank_message.split("\n")
      expect(rank_lines[4]).to include("omgrr")
      expect(rank_lines[5]).to include("bigswifty")
      expect(rank_lines[6]).to include("farnswurth")
    end

    it "returns an error if the requested game type doesn't exist" do
      boy = DummyBoy.new

      rank_message = boy.rank("!rank foobar")
      expect(rank_message).to eq("The game type 'foobar' does not exist")
    end

    it "returns an error if there is no requested type" do
      boy = DummyBoy.new

      rank_message = boy.rank("!rank")
      expect(rank_message).to eq("You must request a game type")
    end
  end
end
