class Dashboard::PagesController < ApplicationController
    before_filter :autorization_check

    layout "dashboard"

    def home
        @nominations = Nomination.order("name").all
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
