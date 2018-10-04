namespace :kq do
    desc "Recalculate scores for a tournament"
    task :recalc, [ :slug ] => :environment do |_, args|
        Rails.logger.debug "Rake task: Processing tournament with slug #{args[:slug]}"

        tournament = Tournament.find_by(slug: args[:slug])

        if tournament
            CalculateScoresJob.perform_now(tournament)
        else
            Rails.logger.error "A tournament with that slug was not found."
        end
    end
end
