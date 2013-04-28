class VotesController < ApplicationController
    before_filter :autorization_check

    def index
        @votes = Vote.find(:all, :conditions => [ "user_id = ?", current_user.id ])
    end

    def new
        @title = I18n.t("shared.common.votes.new.title")
        if params[:candidate_id]
            @candidate = Candidate.find(params[:candidate_id])
            @vote = @candidate.votes.new
        else
            @vote = Vote.new
        end
    end

    def create
        if params[:candidate_id]
            @candidate = Candidate.find(params[:candidate_id])
            @vote = @candidate.votes.new(params[:vote].merge({ :user_id => current_user.id }))
        else
            @vote = Vote.new(params[:vote].merge({ :user_id => current_user.id }))
        end
        if params[:cancel_button] || @vote.save
            redirect_to root_path
        else
            render :new
        end
    end
end
