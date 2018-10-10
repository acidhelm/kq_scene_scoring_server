require "test_helper"

class TournamentsHelperTest < ActionView::TestCase
    def verify_scores(tournament)
        if tournament.user.api_key.blank?
            flunk "You must set the \"KQSS_TEST_USER_API_KEY\"" \
                    " environment variable to run this test."
        end

        scoring_tournament = nil

        VCR.use_cassette("calc_scores_test_#{tournament.slug}") do
            scoring_tournament = TournamentsHelper.calc_scores(
                                     slug: tournament.slug, subdomain: nil,
                                     api_key: tournament.user.api_key)
        end

        assert_equal scoring_tournament.scene_scores.size, tournament.scene_scores.size

        scoring_tournament.scene_scores.each do |s|
            ranked_scene = tournament.scene_scores.find_by(name: s.name)
            assert_not_nil ranked_scene
            assert_equal ranked_scene.score, s.score
        end
    end

    test "Calculate scores for the 4-team tournament" do
        verify_scores(tournaments(:live_data_4teams))
    end

    test "Calculate scores for KQ 25" do
        verify_scores(tournaments(:live_data_kq25))
    end
end
