class Dashboard::PagesController < ApplicationController
    before_filter :autorization_check
    caches_action :home, :layout => false

    layout "dashboard"

    def home
        @nominations = Nomination.order("name").all
        #@top_now = params[:top].to_i || 10
        #@top = @top_now == 10 ? 5 : 10
        @top = 5
        @top_now = 10
        respond_to do |format|
            format.html
            format.xls { response.headers['Content-Disposition'] = "attachment; filename=\"#{t('shared.excel.book_names.nominations')}.xls\"" }
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
