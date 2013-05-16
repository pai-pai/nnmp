class Dashboard::CandidatesController < ApplicationController
    before_filter :admin_check

    layout "dashboard"

    def index
        @title = I18n.t("shared.common.candidates.title")
        @candidates = Candidate.order("fam_name, first_name, sec_name").all
        cookies.permanent[:visited] = "visit"
    end

    def new
    end

    def create
    end

    def show
    end

    def move_votes
        @from_candidate = Candidate.find( params[:from] )
        @to_candidate = Candidate.find( params[:to] )
        @votes = Vote.find_all_by_candidate_id( @from_candidate.id )
        if !@votes.blank?
            @votes.each do |vote|
                vote.update_attributes( :candidate_id => @to_candidate.id )
            end
        end
        render :partial => "candidates", :locals => { :candidates => Candidate.order("fam_name, first_name, sec_name").all }
    end

    def destroy
        @candidate = Candidate.find(params[:id])
        @candidate.destroy
        @val = params[:id]
    end
end
