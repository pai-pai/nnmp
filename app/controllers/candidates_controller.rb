class CandidatesController < ApplicationController
    before_filter :autorization_check

    helper_method :sort_column, :sort_direction

    def index
        @title = I18n.t('shared.common.candidates.title')
        if sort_column == "votes"
            @candidates = Candidate.all.sort! { |c1, c2| c1.votes.count <=> c2.votes.count }
            sort_direction == "desc" ? @candidates.reverse! : @candidates
        elsif sort_column == "nomination_id"
            @candidates = Candidate.all.sort! { |c1, c2| Nomination.find(c1.nomination_id).name <=> Nomination.find(c2.nomination_id).name }
            sort_direction == "desc" ? @candidates.reverse! : @candidates
        elsif sort_column == "org_id"
            @candidates = Candidate.all.sort! { |c1, c2| Org.find(c1.org_id).name <=> Org.find(c2.org_id).name }
            sort_direction == "desc" ? @candidates.reverse! : @candidates
        else
            @candidates = Candidate.order(sort_column + " " + sort_direction)
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
    end

    def new
    end

    def create
    end

    def show
        @candidate = Candidate.find(params[:id])
        if current_user.admin?
            @votes = Vote.find(:all, :conditions => [ "candidate_id = ?", "%#{params[:id]}%" ])
        else
            @votes = Vote.find(:all, :conditions => [ "candidate_id = ? AND user_id = ?", "%#{params[:id]}%", current_user.id ])
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
