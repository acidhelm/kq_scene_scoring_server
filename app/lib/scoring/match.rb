# frozen_string_literal: true

module Scoring

class Match
    attr_reader :points

    def initialize(challonge_obj, match_values)
        @team1_id = challonge_obj[:player1_id]
        @team2_id = challonge_obj[:player2_id]

        play_order = challonge_obj[:suggested_play_order]
        @points = match_values[play_order - 1]
    end

    def has_team?(team_id)
        @team1_id == team_id || @team2_id == team_id
    end
end

end
