require "test_helper"

class CalculateScoresJobTest < ActiveJob::TestCase
    test "Test that a tournament is marked as complete" do
        tournament = tournaments(:live_data_kq25)
        check_api_key(tournament.user)

        assert_not tournament.complete

        VCR.use_cassette("calc_scores_test_#{tournament.slug}") do
            CalculateScoresJob.perform_now(tournament)
        end

        # `TournamentsHelperTest` already tests the code that builds a
        # `Scoring::Tournament`, so we just have to test the database
        # calls that `CalculateScoresJob` does after it builds a
        # `Scoring::Tournament`.
        # TODO: More checks.
        assert tournament.complete
    end
end
