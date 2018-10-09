require "test_helper"

class TournamentTest < ActiveSupport::TestCase
    def setup
        @tournament = tournaments(:one)
    end

    test "Try to save a tournament with an illegal title" do
        @tournament.title = ""
        assert_not @tournament.save
    end

    test "Try to save a tournament with an illegal slug" do
        @tournament.slug = ""
        assert_not @tournament.save
    end
end
