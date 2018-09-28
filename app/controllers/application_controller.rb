class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    #
    # This is just a proof of concept to get the scene-wide score calculations
    # running in a Rails app.
    #

    Options = Struct.new(:tournament_name, :api_key, :use_cache, :update_cache) do
        def initialize
            # Set up defaults.  The tournament name and API key members default to
            # values in ENV, to stay compatible with the old method of always reading
            # those strings from ENV.
            self.tournament_name = ENV["CHALLONGE_SLUG"]
            self.api_key = ENV["CHALLONGE_API_KEY"]
            self.use_cache = false
            self.update_cache = false
        end
    end

    def root
        tournament = Scoring::Tournament.new(Options.new)
        output = "No brackets were loaded."

        if tournament.load
            tournament.calculate_points

            output = tournament.scene_scores.sort.map(&:to_s).join("\n")
        end

        render plain: output
    end
end
