require "application_system_test_case"

class TournamentsTest < ApplicationSystemTestCase
    setup :setup_log_in

    test "Check the tournament list" do
        assert_selector "h1", text: "Tournament list for #{@user.user_name}"

        # The footer should have three links.
        assert_link "Calculate scores for a new tournament",
                    href: new_user_tournament_path(@user), exact: true
        assert_link "View this user's info", href: user_path(@user), exact: true
        assert_link "Log out", href: logout_path, exact: true

        # Check the column headers in the tournament table.
        header_text = %w(Title Challonge\ ID Subdomain Complete? Links Actions)

        page.all("th").each_with_index do |th, i|
            assert th.text == header_text[i]
        end

        # Check the list of tournaments.
        page.all("tbody tr").each_with_index do |tr, t|
            tournament = @user.tournaments[t]

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
                        assert td.has_link? "View scores",
                               href: user_tournament_path(@user, tournament),
                               exact: true
                    when 5
                        assert td.has_link? "Kiosk",
                               href: tournament_kiosk_path(tournament.slug),
                               exact: true
                    when 6
                        if tournament.subdomain.present?
                            href = "https://#{tournament.subdomain}."
                        else
                            href = "https://"
                        end

                        href << "challonge.com/#{tournament.slug}"

                        assert td.has_link? "Challonge bracket", href: href, exact: true
                    when 7
                        assert td.has_link? "Change settings",
                               href: edit_user_tournament_path(@user, tournament),
                               exact: true
                    when 8
                        assert td.has_link? "Delete",
                               href: user_tournament_path(@user, tournament),
                               exact: true
                end
            end
        end
    end

    EXPECTED_SCORES = [ %w(New\ York 391.5), %w(Chicago 370.5), %w(Charlotte 316.5),
                        %w(Minneapolis 292.0), %w(Portland 275.0), %w(Columbus 219.5),
                        %w(Kansas\ City 160.5), %w(Seattle 88.0), %w(Madison 73.0),
                        %w(Austin 46.0), %w(San\ Francisco 37.0), %w(CHA 21.0),
                        %w(Los\ Angeles 15.5), %w(Iowa 11.0) ]

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

        assert_selector "th", exact_text: "Rank"
        assert_selector "th", exact_text: "Scene"
        assert_selector "th", exact_text: "Score"

        page.all("tbody tr").each_with_index do |tr, row|
            tr.all("td").each_with_index do |td, i|
                case i
                    when 0
                        assert_equal (row + 1).to_s, td.text
                    when 1
                        assert_equal EXPECTED_SCORES[row][0], td.text
                    when 2
                        assert_equal EXPECTED_SCORES[row][1], td.text
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
        assert_selector "label", text: "Challonge ID:"
        assert_selector "label", text: "Subdomain:"
        assert_button "Create Tournament", exact: true
        assert_link "Back to the tournament list", href: user_tournaments_path(@user),
                    exact: true
    end
end
