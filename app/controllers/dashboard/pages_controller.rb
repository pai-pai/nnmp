class Dashboard::PagesController < ApplicationController
    before_filter :admin_check

    layout "dashboard"

    def home
    end

    def orgs_stat
        @title = I18n.t('shared.dashboard.stat.orgs.title')
    end
end
