class Candidate < ActiveRecord::Base
    attr_accessible :depart,
                    :fam_name,
                    :first_name,
                    :measures,
                    :nomination_id,
                    :org_id,
                    :sec_name,
                    :unit_id,
                    :ward 
    cattr_accessor :offset, :limit

    belongs_to :nomination
    belongs_to :org
    belongs_to :unit

    has_many :votes, :dependent => :destroy

    def paginate(page, per_page)
        self.offset = page
        self.limit = per_page
        self.find_by_sql "SELECT c.id, c.fam_name, c.first_name, c.sec_name, c.nomination_id, c.org_id
                          FROM candidates c
                          LIMIT #{per_page}
                          OFFSET #{(page - 1) * per_page}"
    end

    def self.get_current_year_voted()
        self.joins("LEFT JOIN votes ON votes.candidate_id = candidates.id").where("votes.updated_at >= '#{Time.now.beginning_of_year}'").select("candidates.id,
                                               candidates.fam_name,
                                               candidates.first_name,
                                               candidates.sec_name,
                                               candidates.nomination_id,
                                               candidates.org_id,
                                               count(votes.id)")
    end
end
