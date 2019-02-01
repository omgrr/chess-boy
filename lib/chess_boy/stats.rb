module ChessBoy
  module Stats
    def stats(message_content)
      tokens = message_content.split(" ")
      user = tokens[1]
      type = tokens[2]

      begin
        response = @lichess_client.users.get(user)
      rescue Lichess::Exception::UserNotFound
        return "The user #{user} does not exist"
      end

      if type
        perfs = {}
        perfs[type] = response["perfs"][type]
      else
        perfs = response["perfs"]
      end

      return "Don't know of any type #{type}" if type && perfs[type].nil?

      table = Terminal::Table.new do |t|
        t << ["Game Type", "Games", "Rating"]
        t.add_separator

        perfs.each do |key, value|
          t << [key, value["games"], value["rating"]]
        end
      end

      return "```\n#{table.to_s}\n```"
    end
  end
end
