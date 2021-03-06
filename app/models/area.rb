class Area < ActiveRecord::Base
    attr_accessible :name

    validates_presence_of :name

    has_many :orgs, :dependent => :restrict

    def sort_orgs
        self.orgs.order("id")
    end
end
