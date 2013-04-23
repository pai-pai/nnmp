class Dashboard::PagesController < ApplicationController
    before_filter :admin_check

    layout "dashboard"

    def home
    end
end
