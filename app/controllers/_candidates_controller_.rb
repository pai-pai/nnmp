class CandidatesController < ApplicationController
    before_filter :autorization_check

    helper_method :sort_column, :sort_direction

    def index
        @title = I18n.t('shared.common.candidates.title')
        @direction = params[:sort_dir] || sort_direction
        @sort = params[:sort_col] || sort_column
        if @sort == "votes"
            @candidates = Candidate.all.sort! { |c1, c2| c1.votes.count <=> c2.votes.count }
            @direction == "desc" ? @candidates.reverse! : @candidates
        elsif @sort == "nomination_id"
            @candidates = Candidate.all.sort! { |c1, c2| Nomination.find(c1.nomination_id).name <=> Nomination.find(c2.nomination_id).name }
            @direction == "desc" ? @candidates.reverse! : @candidates
        elsif @sort == "org_id"
            @candidates = Candidate.all.sort! { |c1, c2| Org.find(c1.org_id).name <=> Org.find(c2.org_id).name }
            @direction == "desc" ? @candidates.reverse! : @candidates
        else
            @candidates = Candidate.order(@sort + " " + @direction)
        end
        if !params[:search].blank?
            #@search_phrase = Regexp.new("(" + params[:search].gsub(/( +)/, '|') + ")", true)
            @search_phrase = params[:search].scan(/\S+/)
            tmp = []
            @candidates.each do |c|
                @search_phrase.each do |s|
                    if c.fam_name + c.first_name + c.sec_name =~ Regexp.new("(" + s + ")", true)
                        tmp << c if @search_phrase.index(s) == @search_phrase.size - 1
                    else
                        break
                    end
                end
            end
            @candidates = tmp
        end
        @page = params[:page] || 1
        @page = @page.to_i
        per_page = 50
        @pages = @candidates.size % per_page == 0 ? (1..( @candidates.size / per_page ).to_i).to_a : (1..(( @candidates.size / per_page ).to_i + 1)).to_a
        @candidates = @candidates[( (@page - 1) * per_page )...( @page * per_page )]
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
            @names["names"] = Candidate.order("first_name").all.map { |c| c.first_name.to_s }.uniq.select { |c| c =~ Regexp.new( "^(" + params[:search_first] + ")", true ) }.collect { |c| { "name" => c } }
        elsif params[:search_sec]
            @names["names"] = Candidate.order("sec_name").all.map { |c| c.sec_name.to_s }.uniq.select { |c| c =~ Regexp.new( "^(" + params[:search_sec] + ")", true ) }.collect { |c| { "name" => c } }
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
