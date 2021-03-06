require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
    test "Check the log in page" do
        visit login_url

        assert_selector "label", exact_text: "User name:"
        assert_field "user_name", type: "text"
        assert_selector "label", exact_text: "Password:"
        assert_field "password", type: "password"

        assert_button "Log in", exact: true
    end
end
