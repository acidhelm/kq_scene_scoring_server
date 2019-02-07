require "application_system_test_case"

class TournamentsTest < ApplicationSystemTestCase
    setup :setup_log_in

    test "Check the tournament list" do
        assert_selector "h1", text: "Tournament list for #{@user.user_name}"

        # Check the column headers in the tournament table.
        within "table thead" do
            headers = [ "Title", "Challonge ID", "Subdomain", "Complete?",
                        "Links", "Actions" ]

            headers.each.with_index(1) do |text, i|
                assert_selector "th:nth-child(#{i})", exact_text: text
            end
        end

        # Check the list of tournaments.
        page.all("table tbody tr").each do |tr|
            tournament = Tournament.find(tr[:id].slice(/\d+\z/))

            tr.all("td").each_with_index do |td, i|
                case i
                    when 0
                        assert_equal tournament.title, td.text
                    when 1
                        assert_equal tournament.slug, td.text
                    when 2
                        assert_equal tournament.subdomain, td.text if tournament.subdomain.present?
                    when 3
                        assert_equal tournament.complete ? "Yes" : "No", td.text
                    when 4
                        assert td.has_link? "View scores", exact: true,
                               href: user_tournament_path(@user, tournament)
                    when 5
                        assert td.has_link? "Kiosk", exact: true,
                               href: tournament_kiosk_path(tournament.slug)
                    when 6
                        if tournament.subdomain.present?
                            href = "https://#{tournament.subdomain}."
                        else
                            href = "https://"
                        end

                        href << "challonge.com/#{tournament.slug}"

                        assert td.has_link? "Challonge bracket", href: href, exact: true
                    when 7
                        assert td.has_link? "Change settings", exact: true,
                               href: edit_user_tournament_path(@user, tournament)
                    when 8
                        assert td.has_link? "Delete", exact: true,
                               href: user_tournament_path(@user, tournament)
                end
            end
        end

        # The footer should have three links.
        assert_link "Calculate scores for a new tournament",
                    href: new_user_tournament_path(@user), exact: true
        assert_link "View this user's info", href: user_path(@user), exact: true
        assert_link "Log out", href: logout_path, exact: true
    end

    test "Check the show-tournament page" do
        tournament = tournaments(:live_data_kq25)

        visit user_tournament_url(@user, tournament)

        assert_selector "h1", exact_text: tournament.title
        assert_selector "p strong", exact_text: "Challonge ID:"
        assert_selector "p", text: tournament.slug
        assert_selector "p strong", exact_text: "Subdomain:"
        assert_selector "p", text: tournament.subdomain if tournament.subdomain.present?
        assert_selector "p strong", exact_text: "Complete?"
        assert_selector "p", text: tournament.complete ? "Yes" : "No"
        assert_button "Calculate scores now", exact: true

        within "table" do
            within "thead" do
                [ "Rank", "Scene", "Score" ].each do |text|
                    assert_selector "th", exact_text: text
                end
            end

            within "tbody" do
                tournament.scene_scores.rank_order.each.with_index(1) do |score, i|
                    within "tr:nth-child(#{i})" do
                        assert_selector "td:first-child", exact_text: score.rank.to_s
                        assert_selector "td:nth-child(2)", exact_text: score.name
                        assert_selector "td:nth-child(3)", exact_text: score.score.to_s
                    end
                end
            end
        end

        assert_link "Change this tournament's settings",
                    href: edit_user_tournament_path(@user, tournament), exact: true
        assert_link "Back to the tournament list",
                    href: user_tournaments_path(@user), exact: true
        assert_link "Log out", href: logout_path, exact: true
    end

    test "Check the new-tournament page" do
        visit new_user_tournament_url(@user)

        assert_selector "h1", exact_text: "Calculate scores for a Challonge tournament"
        assert_selector "label", exact_text: "Title:"
        assert_field "tournament_title", type: "text"
        assert_selector "label", text: "Challonge ID:"
        assert_field "tournament_slug", type: "text"
        assert_selector "label", text: "Subdomain:"
        assert_field "tournament_subdomain", type: "text"

        assert_button "Create Tournament", exact: true
        assert_link "Back to the tournament list", href: user_tournaments_path(@user),
                    exact: true
    end

    test "Check the edit-tournament page" do
        tournament = tournaments(:live_data_kq25)

        visit edit_user_tournament_url(@user, tournament)

        assert_selector "h1", exact_text: "Settings for #{tournament.title}"
        assert_selector "label", exact_text: "Title:"
        assert_field "tournament_title", type: "text", with: tournament.title
        assert_selector "label", text: "Challonge ID:"
        assert_field "tournament_slug", type: "text", with: tournament.slug
        assert_selector "label", text: "Subdomain:"
        assert_field "tournament_subdomain", type: "text", with: tournament.subdomain

        if tournament.complete
            assert_checked_field "tournament_complete"
        else
            assert_no_checked_field "tournament_complete"
        end

        assert_button "Update Tournament", exact: true
        assert_link "Cancel", href: "javascript:history.back()", exact: true
    end
end
