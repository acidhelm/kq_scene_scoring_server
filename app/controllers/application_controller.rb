# frozen_string_literal: true

class ApplicationController < ActionController::Base
    include SessionsHelper

    protect_from_forgery with: :exception

    # Checks that a user is logged in.  Actions that require the user to be
    # logged in must call this function as a `before_action` filter.
    def require_login
        if !logged_in?
            store_location
            flash[:notice] = I18n.t("errors.login_required")
            redirect_to login_url
        end
    end

    # Checks that a user is the same as the currently-logged-in user.  Actions
    # that require the user to be logged in must call this function as a
    # `before_action` filter.
    # This renders an error if the user types in, say, "/users/123/tournament/456"
    # when they own tournament 456 but their user ID is not 123.
    def correct_user?
        if !current_user?(@user)
            render plain: I18n.t("errors.page_access_denied"), status: :forbidden
        end
    end

    # Renders a 404 error with a message saying that an object was not found.
    # The parameter can be `:match`, `:tournament`, or `:user`.
    def render_not_found_error(type)
        string_id = case type
                        when :tournament
                            "errors.tournament_not_found"
                        when :user
                            "errors.user_not_found"
                    end

        render plain: I18n.t(string_id), status: :not_found
    end

    protected

    def set_tournament_from_slug
        # Challonge treats tournament slugs as case-insensitive, so we use a
        # case-insensitive search, too.
        @tournament = Tournament.readonly.where("lower(slug) = ?",
                                                params[:id].downcase).first

        render_not_found_error(:tournament) if @tournament.blank?
    end
end
