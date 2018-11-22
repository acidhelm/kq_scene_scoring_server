require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
    driven_by :selenium, using: :chrome, screen_size: [ 800, 1000 ]

    # System test classes that need to log in must call this function in their
    # setup step.  The simplest way to do that is:
    #   setup :setup_log_in
    def setup_log_in
        @user = users(:test_user)

        if @user.api_key.blank?
            flunk "You must set the \"KQSS_TEST_USER_API_KEY\"" \
                    " environment variable to run system tests."
        end

        log_in_as(@user)
    end

    def log_in_as(user, password = "password")
        visit login_url

        fill_in :user_name, with: user.user_name
        fill_in :password, with: password
        click_on "Log in"

        assert_current_path(user_path(user))
    end

    def take_failed_screenshot
        false
    end
end
