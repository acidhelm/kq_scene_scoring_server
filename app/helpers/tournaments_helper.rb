module TournamentsHelper
    # Returns a Scoring::Tournament object whose `scene_scores` member is
    # filled in.
    def self.calc_scores(slug:, subdomain:, api_key:)
        if subdomain.present?
            tournament_id = "#{subdomain}-#{slug}"
        else
            tournament_id = slug
        end

        tournament = Scoring::Tournament.new(id: tournament_id, api_key: api_key)

        tournament.calculate_points if tournament.load

        tournament
    end
end
