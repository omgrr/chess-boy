module ChessBoy
  module Stats

    SCOREBOARD_GAME_TYPE_TRACKING = ["bullet", "blitz", "rapid", "puzzle"]

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
      all_stats = []

      return "You must request a game type" if type.nil?
      return "The game type 'foobar' does not exist" unless ChessBoy::GAME_TYPES.include?(type)

      _get_user_info.each do |user_info|
        all_stats << _parse_user_info_for_type(user_info, type)
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

    def scoreboard(_message_content)
      all_stats = {}

      _get_user_info.each do |user_info|
        SCOREBOARD_GAME_TYPE_TRACKING.each do |type|
          all_stats[type] ||= []
          all_stats[type] << _parse_user_info_for_type(user_info, type)
        end
      end

      SCOREBOARD_GAME_TYPE_TRACKING.each do |type|
        all_stats[type].sort_by! { |stat| stat["rating"] }.reverse!
      end

      table = Terminal::Table.new(title: "SCOREBOARD", headings: SCOREBOARD_GAME_TYPE_TRACKING) do |t|
        @users.length.times do |i|
          row = []
          SCOREBOARD_GAME_TYPE_TRACKING.each do |type|
            user_stat = all_stats[type][i]
            row << "#{user_stat["user"]}: #{user_stat["rating"]}"
          end

          t << row
        end
      end

      table.columns.length.times do |i|
        table.align_column(i, :right)
      end

      return "```\n#{table.to_s}```"
    end

    private

    def _get_user_info
      @lichess_client.users.get(@users)
    end

    def _parse_user_info_for_type(user_info, type)
      user_stats = {}

      return "The game type '#{type}' does not exist" if user_info["perfs"][type].nil?
      user_stats = user_info["perfs"][type]
      user_stats["user"] = user_info["id"]

      user_stats
    end
  end
end
