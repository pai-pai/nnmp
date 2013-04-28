class Candidate < ActiveRecord::Base
    attr_accessible :depart, :fam_name, :first_name, :sec_name, :ward, :org_id, :unit_id, :nomination_id

    belongs_to :nomination
    belongs_to :org
    belongs_to :unit

    has_many :votes
end