class Dashboard::PagesController < ApplicationController
    before_filter :autorization_check

    layout "dashboard"

    def home
        @nominations = Nomination.order("name").all
        respond_to do |format|
            format.html
            format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=\"#{t('shared.excel.book_names.nominations')}.xlsx\"" }
        end
    end

    def home_orgs
        @orgs = Org.order("id").all
    end

    def get_comment
        vote = Vote.find(params[:vote_id])
        if !vote.comment.blank?
            render :partial => "vote", :locals => { :vote => vote }
        else
            render :text => ""
        end
    end
end
