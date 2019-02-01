module ChessBoy
  module Basics
    def ping(timestamp)
      "Pong! Responded in #{Time.now - timestamp} seconds"
    end
  end
end
