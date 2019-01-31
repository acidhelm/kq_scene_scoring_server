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
end
