class Org < ActiveRecord::Base
    attr_accessible :name, :area_id

    validates_presence_of :name

    has_many :units
    belongs_to :area
end
