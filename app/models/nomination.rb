class Nomination < ActiveRecord::Base
    attr_accessible :desc, :name

    validates_presence_of :name
    validates_uniqueness_of :name

    has_many :candidates, :dependent => :restrict

    def top_candidates( num )
        if !num.blank?
            if num.is_a? Integer
                Candidate.find_by_sql "SELECT c.id, c.fam_name, c.first_name, c.sec_name
                                   FROM candidates c
                                   LEFT JOIN votes v ON v.candidate_id=c.id
                                   WHERE c.nomination_id=#{self.id}
                                   GROUP BY c.id
                                   ORDER BY COUNT(v.id) DESC
                                   LIMIT #{num}"
            else
                Candidate.find_by_nomination_id(self.id).limit(5)
            end
        else
            Candidate.find_by_nomination_id(self.id).limit(5)
        end
    end
end
