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
            redirect_to user_tournament_path(@user, @tournament),
                        notice: I18n.t("notices.tournament_created")
        else
            render :new
        end
    end

    def update
        if @tournament.update(tournament_params)
            redirect_to user_tournament_path(@user, @tournament),
                        notice: I18n.t("notices.tournament_updated")
        else
            render :edit
        end
    end

    def refresh
        tournament = TournamentsHelper.calc_scores(
                         slug: @tournament.slug, subdomain: @tournament.subdomain,
                         api_key: @user.api_key)

        if tournament.scene_scores.blank?
            render plain: "No brackets could be loaded."
            return
        end

        @tournament.with_lock do
            tournament.scene_scores.each do |scene|
                scene_score = @tournament.scene_scores.find_or_initialize_by(name: scene.name)
                scene_score.score = scene.score
                scene_score.save
            end

            @tournament.save
        end

        msg = +""

        @tournament.scene_scores.sort_by(&:score).reverse_each do |scene|
            msg << "#{scene.name} has #{scene.score} points.\n"
        end

        render plain: msg
    end

    def destroy
        @tournament.destroy
        redirect_to({ action: "index" }, notice: I18n.t("notices.tournament_deleted"))
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
