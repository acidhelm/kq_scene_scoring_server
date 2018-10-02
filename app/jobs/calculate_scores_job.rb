class CalculateScoresJob < ApplicationJob
    queue_as :default

    def perform(tournament)
        Rails.logger.debug "CalculateScoresJob: Processing the tournament '#{tournament.title}'"

        scoring_tournament = TournamentsHelper.calc_scores(
                                 slug: tournament.slug,
                                 subdomain: tournament.subdomain,
                                 api_key: tournament.user.api_key)

        if scoring_tournament.scene_scores.blank?
            Rails.logger.error "No brackets could be loaded."
            return
        end

        tournament.with_lock do
            scoring_tournament.scene_scores.each do |scene|
                scene_score = tournament.scene_scores.find_or_initialize_by(name: scene.name)
                scene_score.score = scene.score
                scene_score.save
            end

            tournament.save
        end
    end
end
