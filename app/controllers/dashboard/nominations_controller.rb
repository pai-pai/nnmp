class Dashboard::NominationsController < ApplicationController
    before_filter :admin_check

    layout "dashboard"

    def index
        @title = I18n.t("shared.nominations.common.title")
        @nominations = Nomination.order("name").all
        @nomination = Nomination.new
    end

    def create
        @nomination = Nomination.create!(params[:nomination])
        respond_to do |format|
            format.js
            format.html
        end
    end

    def destroy
    end
end
