class Nomination < ActiveRecord::Base
    attr_accessible :desc, :name

    validates_presence_of :name
    validates_uniqueness_of :name

    has_many :candidates, :dependent => :restrict
end
