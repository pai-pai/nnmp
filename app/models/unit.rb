class Unit < ActiveRecord::Base
    attr_accessible :name, :org_id

    validates_presence_of :org

    belongs_to :org
end
