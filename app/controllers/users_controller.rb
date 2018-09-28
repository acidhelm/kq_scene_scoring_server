# frozen_string_literal: true

class UsersController < ApplicationController
    before_action :set_user
      # before_action :require_login
      # before_action :correct_user?

    def show
    end

    def edit
    end

    def update
        if @user.update(user_params)
            redirect_to @user, notice: "The user has been updated."
        else
            render :edit
        end
    end

    private
    def set_user
        @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render plain: "That user was not found.", status: :not_found
    end

    def user_params
        params.require(:user).permit(:api_key, :password, :password_confirmation)
    end
end
