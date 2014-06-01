class Dashboard::PagesController < ApplicationController
    before_filter :autorization_check
    #caches_action :home, :layout => false

    layout "dashboard"

    def home
        #expire_action(:controller => '/dashboard/pages', :action => 'home')
        @nominations = Nomination.order("name").all
        if !params[:top].blank?
            @top_now = params[:top].to_i
            @top_text = I18n.t('shared.dashboard.common.top_all')
        else
            @top = 10
            @top_text = I18n.t('shared.dashboard.common.top_text') + @top.to_s
        end
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
