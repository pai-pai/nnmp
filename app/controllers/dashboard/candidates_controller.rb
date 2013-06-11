class Dashboard::CandidatesController < ApplicationController
    before_filter :autorization_check
    caches_action :index, :layout => false

    layout "dashboard"

    def index
        @title = I18n.t("shared.common.candidates.title")
        @candidates = Candidate.order("fam_name, first_name, sec_name, id").all
        cookies.permanent[:visited] = "visit"
    end

    def show
        session[:layout] = true
        @candidate = Candidate.find(params[:id])
        @title = @candidate.fam_name + " " + @candidate.first_name + " " + @candidate.sec_name
        if current_user.admin?
            @votes = Vote.find(:all, :order => "id", :conditions => [ "candidate_id = ?", "#{params[:id]}" ])
        else
            @votes = Vote.find(:all, :order => "id", :conditions => [ "candidate_id = ? AND user_id = ?", "#{params[:id]}", current_user.id ])
        end
        render "/candidates/show"
    end

    def get_to_edit
        expire_action(:controller => '/dashboard/candidates', :action => 'index')
        val = params[:candidate_id]
        render :partial => "edit", :locals => { :candidate => Candidate.find(val) }
    end

    def update
        expire_action(:controller => '/dashboard/candidates', :action => 'index')
        @candidate = Candidate.find(params[:id]).update_attributes(params[:candidate])
        @candidates = Candidate.order("fam_name, first_name, sec_name, id").all
        respond_to do |format|
            format.js
        end
    end

    def move_votes
        expire_action(:controller => '/dashboard/candidates', :action => 'index')
        @from_candidate = Candidate.find( params[:from] )
        @to_candidate = Candidate.find( params[:to] )
        @votes = Vote.find_all_by_candidate_id( @from_candidate.id )
        if !@votes.blank?
            @votes.each do |vote|
                vote.update_attributes( :candidate_id => @to_candidate.id )
            end
        end
        render :partial => "candidates", :locals => { :candidates => Candidate.order("fam_name, first_name, sec_name, id").all }
    end

    def destroy
        expire_action(:controller => '/dashboard/candidates', :action => 'index')
        @candidate = Candidate.find(params[:id])
        @candidate.destroy
        @val = params[:id]
    end
end
