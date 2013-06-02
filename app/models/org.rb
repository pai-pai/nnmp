class Org < ActiveRecord::Base
    attr_accessible :name, :area_id

    validates_presence_of :name

    has_many :units
    has_many :candidates
    belongs_to :area

    def top_candidates( num )
        if !num.blank?
            num = 5 if !num.is_a? Integer
            Candidate.find_by_sql "SELECT c.id, c.fam_name, c.first_name, c.sec_name
                                   FROM candidates c
                                   LEFT JOIN votes v ON v.candidate_id=c.id
                                   WHERE c.org_id=#{self.id}
                                   GROUP BY c.id
                                   ORDER BY COUNT(v.id) DESC
                                   LIMIT #{num}"
        else
            Candidate.find_by_sql "SELECT c.id, c.fam_name, c.first_name, c.sec_name
                                   FROM candidates c
                                   LEFT JOIN votes v ON v.candidate_id=c.id
                                   WHERE c.org_id=#{self.id}
                                   GROUP BY c.id
                                   ORDER BY COUNT(v.id) DESC"
        end
    end
end
