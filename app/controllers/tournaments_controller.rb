# frozen_string_literal: true

class TournamentsController < ApplicationController
    USER_ONLY_METHODS = %i(index new create)

    before_action :set_user, only: USER_ONLY_METHODS
    before_action :set_tournament, except: USER_ONLY_METHODS
    before_action :require_login
    before_action :correct_user?

    def index
        @tournaments = Tournament.all
    end

    def show
    end

    def new
        @tournament = @user.tournaments.new
    end

    def edit
    end

    def create
        @tournament = @user.tournaments.new(tournament_params)

        if @tournament.save
            redirect_to user_tournament_path(@user, @tournament), notice: 'The tournament was successfully created.'
        else
            render :new
        end
    end

    def update
        if @tournament.update(tournament_params)
            redirect_to user_tournament_path(@user, @tournament), notice: 'The tournament was successfully updated.'
        else
            render :edit
        end
    end

    def destroy
        @tournament.destroy
        redirect_to({ action: "index" }, notice: 'The tournament was successfully destroyed.')
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
        render_not_found_error(:user)
    end

    def set_tournament
        @user = User.find(params[:user_id])
        @tournament = @user.tournaments.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render_not_found_error(:tournament)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
        params.require(:tournament).permit(:title, :slug, :subdomain, :complete)
    end
end
