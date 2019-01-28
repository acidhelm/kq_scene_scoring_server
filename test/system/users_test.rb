require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
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

    test "Check the user settings page" do
        new_password = "B055man!69"

        visit edit_user_url(@user)

        fill_in "user_api_key", with: "buffythevampireslayer"
        fill_in "user[password]", with: new_password
        fill_in "user[password_confirmation]", with: new_password

        click_on "Update User"

        assert_current_path(user_path(@user))
    end

    test "Check the user properties page" do
        visit user_url(@user)

        assert_selector "h1", exact_text: "Account settings for #{@user.user_name}"
        assert_selector "strong", exact_text: "API key:"
        assert_text @user.api_key

        assert_link "View this user's tournaments", href: user_tournaments_path(@user), exact: true
        assert_link "Change this user's settings", href: edit_user_path(@user), exact: true
        assert_link "Log out", href: logout_path, exact: true
    end
end
