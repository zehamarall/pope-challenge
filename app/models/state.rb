class State < ActiveRecord::Base
  has_many :cities
  validates :acronym, :name, presence: true, uniqueness: true
  validates :acronym,  length: { is: 2 }
end
