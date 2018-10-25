# frozen_string_literal: true

module Scoring

class Tournament
    attr_reader :scene_scores, :complete

    def initialize(id:, api_key:)
        @brackets = []
        @scene_scores = []
        @complete = false
        @id = id
        @api_key = api_key
    end

    # Reads the Challonge bracket with the ID that was passed to the constructor,
    # and fills in all the data structures that represent that bracket.
    # Returns true if at least one bracket was loaded, and false otherwise.
    def load
        tournament_id = @id
        all_brackets_loaded = true

        while tournament_id
            Rails.logger.debug "Reading the bracket \"#{tournament_id}\""

            bracket = Bracket.new(id: tournament_id, api_key: @api_key)

            if !bracket.load
                all_brackets_loaded = false
                break
            end

            @brackets << bracket

            scenes = {}

            bracket.players.each_value do |team|
                team.each do |player|
                    scenes[player.scene] ||= []
                    scenes[player.scene] << player
                end
            end

            scene_list = scenes.map do |scene, players|
                "#{scene} has #{players.size} players: " +
                  players.map(&:name).join(", ")
            end

            Rails.logger.info scene_list.join("\n")

            tournament_id = bracket.config.next_bracket
        end

        return false if @brackets.empty?

        # Check that all the config files have the same max_players_to_count.
        values = @brackets.map { |b| b.config.max_players_to_count }

        if values.count(values[0]) != values.size
            msg = "ERROR: All brackets must have the same \"max_players_to_count\"."
            Rails.logger.error msg
            raise msg
        end

        # If we loaded all the brackets in the list of brackets, set our
        # `complete` member based on the complete state of the last bracket.
        # We only check the last bracket because previous brackets in the
        # sequence are not guaranteed to be marked as complete on Challonge.
        # For an example, see "bb3wc".  The BB3 wild card bracket was not
        # marked as complete because play stopped once it got down to 4 teams.
        @complete = all_brackets_loaded && @brackets.last.complete?

        true
    end

    def calculate_points
        @brackets.each(&:calculate_points)
        calculate_scene_points
    end

    protected

    # Calculates how many points each scene has earned in the tournament.
    # Sets `@scene_scores` to an array of `Scene` objects.
    def calculate_scene_points
        # Collect the scores of all players from the same scene.  Since a player
        # may be in multiple brackets, we find their greatest score across
        # all brackets.
        # `player_scores` is a hash from a Player object's hash to the Player object.
        # This is a hash to make lookups easier; the keys aren't used after
        # this loop.
        player_scores = @brackets.each_with_object({}) do |bracket, scores|
            bracket.players.each_value do |team_players|
                team_players.each do |player|
                    key = player.hash

                    if !scores.key?(key) || player.points > scores[key].points
                        scores[key] = player
                    end
                end
            end
        end

        # Assemble the scores from the players in each scene.  `scene_scores`
        # is a hash from a scene name to an array that holds the scores of all
        # the players in that scene.
        scene_scores = player_scores.each_value.each_with_object({}) do |player, scores|
            scores[player.scene] ||= []
            scores[player.scene] << player.points
        end

        @scene_scores = scene_scores.map do |scene, scores|
            # If a scene has more players than the max number of players whose
            # scores can be counted, drop the extra players' scores.
            # Sort the scores for each scene in descending order, so we only
            # keep the highest scores.
            max_players_to_count = @brackets[0].config.max_players_to_count
            scores.sort!.reverse!

            if scores.size > max_players_to_count
                dropped = scores.slice!(max_players_to_count..-1)

                Rails.logger.info "Dropping the #{dropped.size} lowest scores from #{scene}:" +
                                  dropped.join(", ")
            end

            # Add up the scores for this scene.
            Scene.new(scene, scores)
        end
    end
end

end
