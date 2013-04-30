class Dashboard::OrgsController < ApplicationController
    before_filter :autorization_check

    layout "dashboard"

    def index
        @title = I18n.t("shared.orgs.common.title")
        @areas = Area.order("id").all
        @org = Org.new
    end

    def create
        @org = Org.create!(params[:org])
        respond_to do |format|
            format.js
            format.html
        end
    end

    def destroy
    end
end
