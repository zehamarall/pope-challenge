class LeadInfo < ActiveRecord::Base
  belongs_to :lead
  def some_info_filled?
    [twitter, facebook, linkedin, website].any? { |info| !info.blank? }
  end
end
