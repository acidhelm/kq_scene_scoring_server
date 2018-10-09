require "test_helper"

class SceneScoreTest < ActiveSupport::TestCase
    def setup
        @score = scene_scores(:one)
    end

    test "Update a score" do
        @score.rank = 2
        @score.score = 37.42
        assert @score.save
    end

    test "Try to save a score with an illegal name" do
        @score.name = ""
        assert_not @score.save
    end

    test "Try to save a score with an illegal score" do
        @score.score = -1
        assert_not @score.save
    end

    test "Try to save a score with an illegal rank" do
        @score.rank = -2
        assert_not @score.save
    end
end
