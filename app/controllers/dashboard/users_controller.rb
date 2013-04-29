class Dashboard::UsersController < ApplicationController
    before_filter :admin_check

    layout "dashboard"

    def index
        @title = I18n.t("shared.dashboard.users.title")
        @users = User.order("email asc").all
    end

    def new
        @title = I18n.t("shared.users.adding.title")
        @user = User.new
    end

    def create
        @user = User.new(params[:user])
        if @user.save
            redirect_to dashboard_users_path
        else
            render 'new'
        end
    end

    def show
        @user = User.find(params[:id])
    end

    def destroy
        User.find(params[:id]).destroy
        redirect_to dashboard_users_path
    end
end
