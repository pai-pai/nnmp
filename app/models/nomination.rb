class Nomination < ActiveRecord::Base
    attr_accessible :desc, :name

    validates_presence_of :name
    validates_uniqueness_of :name

    has_many :candidates, :dependent => :restrict

    def top_candidates(num)
        candidates = self.candidates.select(
            "candidates.id, candidates.fam_name,
            candidates.first_name, candidates.sec_name,
            candidates.org_id,
            count(votes.id) AS votes_count, count(CASE
                                                    WHEN votes.updated_at >= '#{Time.now.beginning_of_year}' THEN 1
                                                    ELSE NULL
                                                  END) AS votes_count_this_year").
            joins(:votes).
            where("votes.updated_at >= '#{Time.now.beginning_of_year}'").
            group("candidates.id").
            order("votes_count DESC")
        limit = num
        if num.blank? or !num.is_a? Integer
            candidates = candidates.limit(limit)
        end
        return candidates
    end
end