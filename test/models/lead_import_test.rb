require 'test_helper'

class LeadImportTest < ActiveSupport::TestCase
  should validate_presence_of(:file)
  should validate_uniqueness_of(:file)

  test "can return lines from file" do
    @simple = build(:simple_import)

    assert @simple.lines.size == 2

  end

  test "when import it" do

    @simple.import!

    assert @simple.imported
  end
end
