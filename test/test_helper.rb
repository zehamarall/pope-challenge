ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

Dir[Rails.root.join("test/factories/*.rb")].each{|e| require e}

class Minitest::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end
class Minitest::Spec
  include FactoryGirl::Syntax::Methods
end
class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

require "minitest/reporters"
Minitest::Reporters.use!
