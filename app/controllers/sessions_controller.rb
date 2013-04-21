class SessionsController < ApplicationController
    def new
        @title = I18n.t("shared.users.login.title")
    end

    def create
        user = User.find_by_email(params[:session][:email].downcase)
        if user && user.password == params[:session][:password]
            sign_in user
            redirect_to user_path
        else
            render "new"
        end
    end

    def destroy
        sign_out
        redirect_to login_path
    end
end
