module ChessBoy
  module Stats
    def stats(message_content)
      tokens = message_content.split(" ")
      user = tokens[1]
      type = tokens[2]

      if user =~ /^\<\@/
        user_id = user[/\<\@\d+\>/][/\d+/]
        discord_username = @discord_bot.users[user_id.to_i].username

        user = @discord_mappings[discord_username]
      end

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
        t << ["Game Type", "Games", "Rating", "Progression"]
        t.add_separator

        perfs.each do |key, value|
          t << [key, value["games"], value["rating"], value["prog"]]
        end
      end

      return "```\n#{table.to_s}\n```"
    end

    def rank(message_content)
      tokens = message_content.split(" ")
      type = tokens[1]

      return "You must request a game type" if type.nil?

      all_stats = []
      @users.each do |user|
        user_info = @lichess_client.users.get(user)

        user_stats = {}

        return "The game type '#{type}' does not exist" if user_info["perfs"][type].nil?
        user_stats = user_info["perfs"][type]
        user_stats["user"] = user

        all_stats << user_stats
      end

      all_stats.sort_by! { |stat| stat["rating"] }.reverse!

      table = Terminal::Table.new do |t|
        t << ["User", "Rating", "Games", "Progression"]
        t.add_separator

        all_stats.each do |value|
          t << [value["user"], value["rating"], value["games"], value["prog"]]
        end
      end

      return "```\n#{table.to_s}\n```"
    end
  end
end
