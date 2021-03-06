# frozen_string_literal: true

class CalculateScoresJob < ApplicationJob
    queue_as :default

    def perform(tournament)
        Rails.logger.debug "CalculateScoresJob: Processing the tournament '#{tournament.title}'"

        # You can set the `PROCESS_COMPLETE_TOURNAMENTS` variable to any value
        # to always process a tournament, even if it's completed.
        if tournament.complete && !ENV["PROCESS_COMPLETE_TOURNAMENTS"]
            Rails.logger.debug "Returning because the tournament is complete."
            return
        end

        scoring_tournament = TournamentsHelper.calc_scores(
                                 slug: tournament.slug,
                                 subdomain: tournament.subdomain,
                                 api_key: tournament.user.api_key,
                                 logger: Rails.logger)

        if scoring_tournament.scene_scores.blank?
            Rails.logger.error "No brackets could be loaded."
            return
        end

        tournament.with_lock do
            # Create or update `SceneScore` records for each scene.
            scoring_tournament.scene_scores.each do |scene|
                scene_score = tournament.scene_scores.find_or_initialize_by(name: scene.name)
                scene_score.score = scene.score
                scene_score.save
            end

            # Calculate the rank of each scene.  Teams with the same score get
            # the same rank.
            last_rank = -1
            last_score = -1

            tournament.scene_scores.score_order.each.with_index(1) do |scene, i|
                if scene.score != last_score
                    last_score = scene.score
                    scene.rank = i
                    last_rank = i
                else
                    scene.rank = last_rank
                end

                scene.save
            end

            Rails.logger.info "Setting the tournament's complete flag to" \
                                " #{scoring_tournament.complete}"

            tournament.complete = scoring_tournament.complete

            tournament.save
        end
    end
end
