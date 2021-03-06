# frozen_string_literal: true

module TournamentsHelper
    # Returns a KillerQueenSceneScoring::Tournament object whose `scene_scores`
    # member is filled in.
    def self.calc_scores(slug:, subdomain:, api_key:, logger:)
        tournament_id = if subdomain.present?
                            "#{subdomain}-#{slug}"
                        else
                            slug
                        end

        Rails.logger.debug "Processing the tournament '#{tournament_id}'"

        tournament = KillerQueenSceneScoring::Tournament.new(
                       id: tournament_id, api_key: api_key, logger: logger)

        tournament.calculate_points if tournament.load

        tournament
    end
end
