# frozen_string_literal: true

module Scoring

class Config
    attr_reader :base_point_value, :next_bracket, :max_players_to_count,
                :match_values, :teams

    def initialize(config_obj)
        @base_point_value = config_obj[:base_point_value]
        @next_bracket = config_obj[:next_bracket]
        @max_players_to_count = config_obj[:max_players_to_count]
        @match_values = config_obj[:match_values]
        @teams = config_obj[:teams]
    end
end

end
