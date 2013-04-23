class Dashboard::UnitsController < ApplicationController
    before_filter :admin_check

    layout "dashboard"

    def index
        @title = I18n.t("shared.units.common.title")
        @orgs = Org.order("id").all
        @unit = Unit.new
    end

    def create
        @unit = Unit.create!(params[:unit])
        respond_to do |format|
            format.js
            format.html
        end
    end

    def destroy
    end
end
