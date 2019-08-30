require "discordrb"
require "lichess"
require "terminal-table"

require "chess_boy/basics"
require "chess_boy/image"
require "chess_boy/stats"
require "chess_boy/version"

require "chess_boy/client"

module ChessBoy
  GAME_TYPES = ["bullet", "blitz", "rapid", "puzzle", "correspondence", "classical"]
end
