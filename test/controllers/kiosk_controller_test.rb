require "test_helper"

class KioskControllerTest < ActionDispatch::IntegrationTest
    setup do
        @tournament = tournaments(:tournament_1)
        @slug = @tournament.slug
        @bad_slug = @slug.succ
    end

    test "View the kiosk for a tournament" do
        [ @slug, @slug.upcase ].each do |id|
            get tournament_kiosk_url(id)
            assert_response :success
            assert_template "kiosk/show"
        end
    end

    test "Try to view the kiosk for a non-existant tournament" do
        get tournament_kiosk_url(@bad_slug)
        assert_response :not_found
    end
end
