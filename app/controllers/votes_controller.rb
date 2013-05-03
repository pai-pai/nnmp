class VotesController < ApplicationController
    before_filter :autorization_check

    def index
        @votes = Vote.find(:all, :conditions => [ "user_id = ?", current_user.id ])
    end

    def new
        @title = I18n.t("shared.common.votes.new.title")
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
        if params[:cancel_button] || @vote.save
            redirect_to root_path
        else
            render :new
        end
    end

    def get_to_edit
        val = params[:vote_id]
        render :partial => "edit_this_vote", :locals => { :this_vote => Vote.find(val) }
    end

    def update
        @vote = Vote.find(params[:id]).update_attributes(params[:vote])
        @vote = Vote.find(params[:id])
        respond_to do |format|
            format.js
        end
    end

    def destroy
        @vote = Vote.find(params[:id])
        @candidate = @vote.candidate_id
        @vote.destroy
        redirect_to candidate_path(@candidate)
    end
end
