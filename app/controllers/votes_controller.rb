class VotesController < ApplicationController
    before_filter :autorization_check

    def index
        @votes = Vote.find(:all, :conditions => [ "user_id = ?", current_user.id ])
    end

    def new
        if params[:candidate_id]
            @candidate = Candidate.find(params[:candidate_id])
            @vote = @candidate.votes.build
        else
            @vote = Vote.new
        end
    end

    def create
        if params[:candidate_id]
            @candidate = Candidate.find(params[:candidate_id])
            @vote = @candidate.votes.build(params[:vote].merge({ :user_id => current_user.id }))
        else
            @vote = Vote.new(params[:vote].merge({ :user_id => current_user.id }))
        end
        if @vote.save
            redirect_to root_path
        elsif params[:cancel_button]
            redirect_to root_path
        else
            render :new
        end
    end
end
