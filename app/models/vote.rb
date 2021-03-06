class Vote < ActiveRecord::Base
    attr_accessible :comment,
                    :voter_fio,
                    :voter_phone,
                    :user_id,
                    :fam_name,
                    :first_name,
                    :sec_name,
                    :ward,
                    :depart,
                    :org_id,
                    :unit_id,
                    :nomination_id,
                    :candidate_id,
                    :measures

    validates :org_id, :presence => :true, :if => Proc.new { |c| c.unit_id.blank? }, :on => :create
    validates_presence_of :nomination_id, :on => :create

    validate :must_have_any_ident_info, :on => :create

    def must_have_any_ident_info
        if fam_name.blank?
            if first_name.blank? && sec_name.blank? && ward.blank?
                errors.add(:base, "Must have fam_name or first_name and sec_name or ward")
            elsif !sec_name.blank? && first_name.blank? && ward.blank?
                errors.add(:base, "Must have fam_name or first_name and sec_name or ward")
            elsif !first_name.blank? && sec_name.blank? && ward.blank?
                errors.add(:base, "Must have fam_name or first_name and sec_name or ward")
            end
        end
    end

    belongs_to :user
    belongs_to :candidate

    before_create :add_org_id
    before_create :add_or_create_and_add_candidate_id

    MEASURES = [
        [I18n.t("shared.common.votes.measures.kindness"), 1],
        [I18n.t("shared.common.votes.measures.devotion"), 2]
    ]

    #
    def fam_name
        @fam_name
    end

    def fam_name=(new_fam_name)
        @fam_name = new_fam_name
    end
    #
    def first_name
        @first_name
    end

    def first_name=(new_first_name)
        @first_name = new_first_name
    end
    #
    def sec_name
        @sec_name
    end

    def sec_name=(new_sec_name)
        @sec_name = new_sec_name
    end
    #
    def nomination_id
        @nomination_id
    end

    def nomination_id=(new_nomination_id)
        @nomination_id = new_nomination_id
    end
    #
    def org_id
        @org_id
    end

    def org_id=(new_org_id)
        @org_id = new_org_id
    end
    #
    def unit_id
        @unit_id
    end

    def unit_id=(new_unit_id)
        @unit_id = new_unit_id
    end
    #
    def depart
        @depart
    end

    def depart=(new_depart)
        @depart = new_depart
    end
    #
    def ward
        @ward
    end

    def ward=(new_ward)
        @ward = new_ward
    end
    #

    def add_org_id
        self.org_id = Unit.find(self.unit_id).org_id if !self.unit_id.blank? && org_id.blank?
    end

    def add_or_create_and_add_candidate_id
        condition = "c.org_id=#{ org_id } AND c.nomination_id=#{ nomination_id }"
        condition = condition + " AND c.fam_name IN ('#{self.fam_name}', '')" if !self.fam_name.blank?
        condition = condition + " AND c.first_name IN ('#{self.first_name}', '')" if !self.first_name.blank?
        condition = condition + " AND c.sec_name IN ('#{self.sec_name}', '')" if !self.sec_name.blank?
        condition = condition + " AND c.unit_id IN (#{self.unit_id}, '')" if !self.unit_id.blank?
        condition = condition + " AND c.depart IN ('#{self.depart}', '')" if !self.depart.blank?
        condition = condition + " AND c.ward IN ('#{self.ward}', '')" if !self.ward.blank?
        @candidate = Candidate.find_by_sql "SELECT *
                                            FROM candidates c
                                            WHERE #{condition}
                                            ORDER BY c.updated_at
                                            LIMIT 1"
        if @candidate.blank?
            @candidate = Candidate.create!( :fam_name => self.fam_name,
                                            :first_name => self.first_name,
                                            :sec_name => self.sec_name,
                                            :nomination_id => self.nomination_id,
                                            :org_id => self.org_id,
                                            :unit_id => self.unit_id,
                                            :depart => self.depart,
                                            :ward => self.ward )
        else
            @candidate = @candidate[0]
            @candidate.update_attributes(fam_name: self.fam_name) if !self.fam_name.blank?
            @candidate.update_attributes(first_name: self.first_name) if !self.first_name.blank?
            @candidate.update_attributes(sec_name: self.sec_name) if !self.sec_name.blank?
            @candidate.update_attributes(unit_id: self.unit_id) if !self.unit_id.blank?
            @candidate.update_attributes(depart: self.depart) if !self.depart.blank?
            @candidate.update_attributes(ward: self.ward) if !self.ward.blank?
        end

        #@candidate = Candidate.find(:all, :conditions => [ "org_id = ? AND nomination_id = ?", self.org_id, self.nomination_id ])
        #if !@candidate.blank?
        #    @candidate.select! { |cand| cand.fam_name == self.fam_name } if !self.fam_name.blank?
        #    @candidate.select! { |cand| cand.first_name == self.first_name  } if !self.first_name.blank?
        #    @candidate.select! { |cand| cand.sec_name == self.sec_name  } if !self.sec_name.blank?
        #    @candidate.select! { |cand| cand.ward == self.ward  } if !self.ward.blank?
        #    if @candidate.size > 0
        #        @candidate = @candidate.sort! { |cand1, cand2| cand1.updated_at <=> cand2.updated_at }[0]
        #    else
        #        @candidate = Candidate.create!( :fam_name => self.fam_name,
        #                       :first_name => self.first_name,
        #                       :sec_name => self.sec_name,
        #                       :nomination_id => self.nomination_id,
        #                       :org_id => self.org_id,
        #                       :unit_id => self.unit_id,
        #                       :depart => self.depart,
        #                       :ward => self.ward )
        #    end
        #else
        #    @candidate = Candidate.create!( :fam_name => self.fam_name,
        #                       :first_name => self.first_name,
        #                       :sec_name => self.sec_name,
        #                       :nomination_id => self.nomination_id,
        #                       :org_id => self.org_id,
        #                       :unit_id => self.unit_id,
        #                       :depart => self.depart,
        #                       :ward => self.ward )
        #end
        self.candidate_id = @candidate.id
    end
end
