require "test_helper"

class TournamentsControllerTest < ActionDispatch::IntegrationTest
    setup do
        @tournament = tournaments(:one)
        @user = @tournament.user
        @other_tournament = tournaments(:two)
        @other_user = @other_tournament.user
    end

    def update_tournament_params(tournament)
        return { tournament: {
                   title: tournament.title, slug: tournament.slug,
                   complete: !tournament.complete } }
    end

    test "Get the tournaments index" do
        log_in_as(@user)
        assert logged_in?

        get user_tournaments_path(@user)
        assert_response :success
    end

    test "Try to get the tournaments index for a different user" do
        log_in_as(@user)
        assert logged_in?

        get user_tournaments_path(@other_user)
        assert_response :forbidden
    end

    test "Try to get the tournaments index for a non-existant user" do
        get user_tournaments_path(User.ids.max + 1)
        assert_response :not_found
    end

    test "Try to get the tournaments index without logging in" do
        get user_tournaments_path(@user)
        assert_redirected_to login_url
        assert_not flash.empty?
    end

    test "Show a tournament" do
        log_in_as(@user)
        assert logged_in?

        get user_tournament_path(@user, @tournament)
        assert_response :success
    end

    test "Try to show a tournament for a different user" do
        log_in_as(@user)
        assert logged_in?

        get user_tournament_path(@other_user, @other_tournament)
        assert_response :forbidden
    end

    test "Try to show a tournament without logging in" do
        get user_tournament_path(@user, @tournament)
        assert_redirected_to login_url
        assert_not flash.empty?
    end

    test "Try to show a non-existant tournament" do
        get user_tournament_path(@user, Tournament.ids.max + 1)
        assert_response :not_found
    end

    test "Get the new-tournament page" do
        log_in_as(@user)
        assert logged_in?

        get new_user_tournament_path(@user)
        assert_response :success
        assert_template "tournaments/new"
    end

    test "Try to get the new-tournament page for a different user" do
        log_in_as(@user)
        assert logged_in?

        get new_user_tournament_path(@other_user)
        assert_response :forbidden
    end

    test "Try to get the new-tournament page without logging in" do
        get new_user_tournament_path(@user)
        assert_redirected_to login_url
        assert_not flash.empty?
    end

    test "Get the tournament settings page" do
        log_in_as(@user)
        assert logged_in?

        get edit_user_tournament_path(@user, @tournament)
        assert_response :success
    end

    test "Try to get the tournament settings page for a different user" do
        log_in_as(@user)
        assert logged_in?

        get edit_user_tournament_path(@other_user, @other_tournament)
        assert_response :forbidden
    end

    test "Try to get the tournament settings page without logging in" do
        get edit_user_tournament_path(@user, @tournament)
        assert_redirected_to login_url
        assert_not flash.empty?
    end

    test "Update a tournament" do
        log_in_as(@user)
        assert logged_in?

        patch user_tournament_path(@user, @tournament),
              params: update_tournament_params(@tournament)

        assert_redirected_to user_tournament_path(@user, @tournament)
    end

    test "Try to update a tournament with invalid params" do
        log_in_as(@user)
        assert logged_in?

        params = update_tournament_params(@tournament)
        params[:tournament][:title] = ""
        params[:tournament][:slug] = ""

        patch user_tournament_path(@user, @tournament), params: params

        assert_response :success
        assert_template "tournaments/edit"
    end

    test "Try to update a tournament for a different user" do
        log_in_as(@user)
        assert logged_in?

        patch user_tournament_path(@other_user, @other_tournament),
              params: update_tournament_params(@other_tournament)

        assert_response :forbidden
    end

    test "Try to update a tournament without logging in" do
        patch user_tournament_path(@user, @tournament),
              params: update_tournament_params(@tournament)

        assert_redirected_to login_url
        assert_not flash.empty?
    end

    test "Create a tournament" do
        log_in_as(@user)
        assert logged_in?

        @tournament.title = "test tourney"
        @tournament.slug = "testslug42"
        params = update_tournament_params(@tournament)

        assert_difference("Tournament.count") do
            post user_tournaments_path(@user), params: params
        end

        assert_response :redirect
    end

    test "Try to create a tournament without logging in" do
        @tournament.title = "test tourney"
        @tournament.slug = "testslug42"
        params = update_tournament_params(@tournament)

        assert_no_difference("Tournament.count") do
            post user_tournaments_path(@user), params: params
        end

        assert_redirected_to login_url
        assert_not flash.empty?
    end

    test "Try to create a tournament with invalid params" do
        log_in_as(@user)
        assert logged_in?

        @tournament.title = ""
        @tournament.slug = ""
        params = update_tournament_params(@tournament)

        assert_no_difference("Tournament.count") do
            post user_tournaments_path(@user), params: params
        end

        assert_response :success
        assert_template "tournaments/new"
    end

    test "Destroy a tournament" do
        log_in_as(@user)
        assert logged_in?

        assert_difference("Tournament.count", -1) do
            delete user_tournament_path(@user, @tournament)
        end

        assert_redirected_to user_tournaments_path(@user)
    end

    test "Try to destroy a tournament without logging in" do
        assert_no_difference("Tournament.count") do
            delete user_tournament_path(@user, @tournament)
        end

        assert_redirected_to login_url
        assert_not flash.empty?
    end
end
