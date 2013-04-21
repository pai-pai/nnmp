class ApplicationController < ActionController::Base
    protect_from_forgery

    include SessionsHelper

    def handle_unverified_request
        sign_out
        super
    end

    def autorization_check
        redirect_to login_path if !signed_in?
    end
end
