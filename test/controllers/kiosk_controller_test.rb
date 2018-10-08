require "test_helper"

class KioskControllerTest < ActionDispatch::IntegrationTest
    test "Try to view the kiosk for a non-existant tournament" do
        get tournament_kiosk_url("foo")
        assert_response :not_found
    end
end
