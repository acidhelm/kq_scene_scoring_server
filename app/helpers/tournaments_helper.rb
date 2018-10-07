# frozen_string_literal: true

module TournamentsHelper
    # Returns a Scoring::Tournament object whose `scene_scores` member is
    # filled in.
    def self.calc_scores(slug:, subdomain:, api_key:)
        tournament_id = if subdomain.present?
                            "#{subdomain}-#{slug}"
                        else
                            slug
                        end

        Rails.logger.debug "Processing the tournament '#{tournament_id}'"

        tournament = Scoring::Tournament.new(id: tournament_id, api_key: api_key)

        tournament.calculate_points if tournament.load

        tournament
    end
end
