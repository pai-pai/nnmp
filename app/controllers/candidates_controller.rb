class CandidatesController < ApplicationController
    before_filter :autorization_check
    caches_action :index, :layout => false

    helper_method :sort_column, :sort_direction

    #caches_page :index

    def index
        @title = I18n.t('shared.common.candidates.title')
        @candidates = Candidate.where("updated_at >= ?", Time.now.beginning_of_year)
                               .order(:fam_name, :first_name, :sec_name, :org_id)
                               .all()
        #if !params[:search].blank?
        #    @search_phrase = params[:search].scan(/\S+/)
        #    tmp = []
        #    @candidates.each do |c|
        #        @search_phrase.each do |s|
        #            if c.fam_name + c.first_name + c.sec_name =~ Regexp.new("(" + s + ")", true)
        #                tmp << c if @search_phrase.index(s) == @search_phrase.size - 1
        #            else
        #                break
        #            end
        #        end
        #    end
        #    @candidates = tmp
        #end
        @page = params[:page] || 1
        #@page = @page.to_i
        #per_page = 50
        #@pages = @candidates.size % per_page == 0 ? (1..( @candidates.size / per_page ).to_i).to_a : (1..(( @candidates.size / per_page ).to_i + 1)).to_a
        #@candidates = Candidate.find_by_sql "SELECT c.id, c.fam_name, c.first_name, c.sec_name, c.nomination_id, c.org_id
        #                  FROM candidates c
        #                  ORDER BY c.fam_name, c.first_name, c.sec_name, c.org_id"
        #@candidates = Candidate.paginate( @page, 3 )
    end

    def new
    end

    def create
    end

    def show
        session[:layout] = nil
        @candidate = Candidate.find(params[:id])
        @title = @candidate.fam_name + " " + @candidate.first_name + " " + @candidate.sec_name
        if current_user.admin?
            @votes = Vote.find(:all, :order => "id", :conditions => [ "candidate_id = ?", "#{params[:id]}" ])
        else
            @votes = Vote.find(:all, :order => "id", :conditions => [ "candidate_id = ? AND user_id = ?", "#{params[:id]}", current_user.id ])
        end
    end

    def get_io
        @names = Hash.new {}
        if params[:search_first]
            @names["names"] = Candidate.find_by_sql("SELECT c.first_name 
                                                     FROM candidates c
                                                     ORDER BY c.first_name").map { |c| c.first_name.to_s }.uniq.select { |c| c =~ Regexp.new( "^(" + params[:search_first] + ")", true ) }.collect { |c| { "name" => c } }
        elsif params[:search_sec]
            @names["names"] = Candidate.find_by_sql("SELECT c.sec_name 
                                                     FROM candidates c
                                                     ORDER BY c.sec_name").map { |c| c.sec_name.to_s }.uniq.select { |c| c =~ Regexp.new( "^(" + params[:search_sec] + ")", true ) }.collect { |c| { "name" => c } }
        end
        respond_to do |format|
           format.json { render :json => @names.to_json }
        end
    end

    private
        def sort_column
            if params[:sort] == "votes"
                "votes"
            else
                Candidate.column_names.include?(params[:sort]) ? params[:sort] : "fam_name"
            end
        end

        def sort_direction
            %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
        end
end
