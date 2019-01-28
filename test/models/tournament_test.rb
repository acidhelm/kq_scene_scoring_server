require "test_helper"

class TournamentTest < ActiveSupport::TestCase
    def setup
        @tournament = tournaments(:tournament_1)
    end

    test "Try to save a tournament with an illegal title" do
        @tournament.title = ""
        assert_not @tournament.save
    end

    test "Try to save a tournament with an empty slug" do
        @tournament.slug = ""
        assert_not @tournament.save
    end

    test "Try to save a tournament with an illegal slug" do
        @tournament.slug = "bad~slug~"
        assert_not @tournament.save
    end

    test "Try to save a tournament with a duplicate slug" do
        t2 = @tournament.dup
        t2.slug.upcase!

        assert_not t2.save
    end
end
