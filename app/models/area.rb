class Area < ActiveRecord::Base
    attr_accessible :name

    validates_presence_of :name

    has_many :orgs
end