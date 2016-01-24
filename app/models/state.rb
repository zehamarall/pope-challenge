class State < ActiveRecord::Base
  has_many :cities
  validates :acronym, presence: true, uniqueness: true
  validates :acronym,  length: { is: 2 }
end
