class Nomination < ActiveRecord::Base
    attr_accessible :desc, :name

    validates_presence_of :name

    has_many :candidates, :dependent => :restrict
end
