class Dashboard::AreasController < ApplicationController
    before_filter :autorization_check

    layout "dashboard"

    def index
        @title = I18n.t("shared.areas.common.title")
        @areas = Area.all
        @area = Area.new
    end

    def create
        @area = Area.create!(params[:area])
        respond_to do |format|
            format.js
            format.html
        end
    end

    def destroy
    end
end
