# frozen_string_literal: true

module Scoring

class Scene
    attr_accessor :name, :score, :num_players

    def initialize(name, player_scores)
        @name = name
        @score = player_scores.sum
        @num_players = player_scores.size
    end

    def to_s
        "#{@name}: #{@score} points from #{@num_players} players"
    end

    def <=>(rhs)
        # Sort by score in descending order so the largest scores come first.
        @score != rhs.score ? rhs.score <=> @score : @name <=> rhs.name
    end
end

end
