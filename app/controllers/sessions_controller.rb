class SessionsController < ApplicationController
    def new
        @title = I18n.t("shared.users.login.title")
    end

    def create
        user = User.find_by_email(params[:session][:email].downcase)
        if user && user.password == params[:session][:password]
            sign_in user
            if user.admin?
                redirect_to dashboard_home_path
            else
                redirect_to root_path
            end
        else
            render "new"
        end
    end

    def destroy
        sign_out
        redirect_to login_path
    end
end
