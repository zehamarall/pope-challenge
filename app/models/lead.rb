class Lead < ActiveRecord::Base
  belongs_to :company
  belongs_to :city
  belongs_to :state
  has_one :lead_info, dependent: :destroy
  validates :email, uniqueness: true
end
