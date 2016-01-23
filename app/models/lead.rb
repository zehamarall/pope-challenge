class Lead < ActiveRecord::Base
  belongs_to :company
  belongs_to :city
  belongs_to :state
end
