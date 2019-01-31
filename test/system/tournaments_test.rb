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
        page.all("tbody tr").each do |tr|
            tr.all("td").each_with_index do |td, i|
                case i
                    when 0, 1
                        # The Name and Challonge ID columns should have text.
                        # We don't check column index 2, the subdomain, because
                        # that can be blank.
                        assert td.text.present?
                    when 3
                        assert td.text == "Yes" || td.text == "No"
                    when 4
                        assert td.has_link? "View scores", exact: true
                    when 5
                        assert td.has_link? "Kiosk", exact: true
                    when 6
                        assert td.has_link? "Challonge bracket", exact: true

                        # Check that the "Challonge" link points to a valid
                        # Challonge URL.
                        uri = URI.parse(td.find("a")[:href])

                        assert uri.host =~ /^([a-zA-Z0-9-]+\.)?challonge\.com$/
                        assert uri.path =~ /^\/\w+$/
                    when 7
                        assert td.has_link? "Change settings", exact: true
                    when 8
                        assert td.has_link? "Delete", exact: true
                end
            end
        end
    end
end
