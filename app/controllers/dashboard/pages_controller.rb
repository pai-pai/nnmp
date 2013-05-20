class Dashboard::PagesController < ApplicationController
    before_filter :autorization_check

    layout "dashboard"

    def home
        @nominations = Nomination.order("name").all
    end

    def orgs_stat
        @title = I18n.t('shared.dashboard.stat.orgs.title')
    end
end
