require 'test_helper'

class LeadTest < ActiveSupport::TestCase
  should validate_uniqueness_of(:email)
end
