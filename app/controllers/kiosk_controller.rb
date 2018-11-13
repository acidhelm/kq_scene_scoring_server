# frozen_string_literal: true

class KioskController < ApplicationController
    before_action :set_tournament_from_slug

    def show
        # The user can set the refresh time by passing the time in seconds as
        # the `t` parameter.
        refresh_time = params[:t] || Rails.configuration.kiosk_refresh_time

        @refresh_tag = @tournament.complete ? "" :
                         "<meta http-equiv='refresh' content='#{refresh_time}'>".html_safe
    end
end
