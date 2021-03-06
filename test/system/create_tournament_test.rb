require "application_system_test_case"

class CreateTournamentTest < ApplicationSystemTestCase
    setup :setup_log_in

    test "Create a tournament and calculate its scores" do
        visit user_tournaments_path(@user)

        click_on "Calculate scores for a new tournament"

        assert_selector "label", exact_text: "Title:"
        assert_field id: "tournament_title", type: "text"
        assert_selector "label", text: "Challonge ID:"
        assert_field id: "tournament_slug", type: "text"
        assert_selector "label", text: "Subdomain:"
        assert_field id: "tournament_subdomain", type: "text"
        assert_button "Create Tournament", exact: true
        assert_link "Back to the tournament list", exact: true,
                    href: user_tournaments_path(@user)

        fill_in :tournament_title, with: "Test BB3 tourney"
        fill_in :tournament_slug, with: "bb3wc"

        assert_difference ->{ @user.tournaments.count } do
            click_on "Create Tournament"
        end

        VCR.use_cassette("create_new_tournament") do
            click_on "Calculate scores now"
        end

        click_on "Back to the tournament list"

        assert_selector "td", exact_text: "Test BB3 tourney"
        assert_selector "td", exact_text: "bb3wc"
    end
end
