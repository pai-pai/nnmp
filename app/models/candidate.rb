class Candidate < ActiveRecord::Base
    attr_accessible :depart, :fam_name, :first_name, :sec_name, :ward, :org_id, :unit_id, :nomination_id

    belongs_to :nomination
    belongs_to :org
    belongs_to :unit

    has_many :votes, :dependent => :destroy

    def self.paginate( page, per_page )
        @pages = (1..( self.count % per_page == 0 ? (self.count / per_page).to_i : ( self.count / per_page ).to_i + 1)).to_a
        self.find_by_sql "SELECT c.fam_name, c.id, c.first_name, c.sec_name, c.nomination_id, c.org_id 
                          FROM candidates c
                          LIMIT #{ per_page } 
                          OFFSET #{ (page - 1) * per_page }"
    end
end
