require "test_helper"

class TournamentsHelperTest < ActionView::TestCase
    setup do
        @tournament = tournaments(:live_data_4teams)
    end

    test "Calculate scores for the 4-team tournament" do
        scoring_tournament = nil

        VCR.use_cassette("calc_scores_small_tournament") do
            scoring_tournament = TournamentsHelper.calc_scores(
                                     slug: "tvtpeasf", subdomain: nil,
                                     api_key: @tournament.user.api_key)
        end

        assert_equal scoring_tournament.scene_scores.size, @tournament.scene_scores.size

        scoring_tournament.scene_scores.each do |s|
            ranked_scene = @tournament.scene_scores.find_by(name: s.name)
            assert_not_nil ranked_scene
            assert_equal ranked_scene.score, s.score
        end
    end
end
