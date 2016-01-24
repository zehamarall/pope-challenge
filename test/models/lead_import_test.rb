require 'test_helper'


class LeadImportTest < ActiveSupport::TestCase
  should validate_presence_of(:file)
  should validate_uniqueness_of(:file)

  setup do
    @simple = build(:simple_import)
  end

  test "can return lines from file" do
    assert @simple.lines.size == 2
  end

  test "create leads when it does not exist" do
    assert_difference "Lead.count", 1 do
      @simple.import!
    end

    assert @simple.process_status == "imported"
    assert @simple.leads_imported == 1
  end

  test "update leads when it exist" do
    first_email = @simple.lines[1][0].strip.downcase

    lead = Lead.create email: first_email

    assert_no_difference "Lead.count", 1 do
      @simple.import!
    end

    lead.destroy

    assert @simple.process_status == "imported"
    assert @simple.leads_imported == 0
    assert @simple.leads_updated == 1
  end
end

class LeadImportWithMoreInfoTest < ActiveSupport::TestCase

  setup do
    @simple = build(:simple_import_with_more_info)
  end

  test "import and update info when info is not blank." do
    leads = nil
    assert_difference "Lead.count", 1 do
      leads = @simple.import!
    end

    assert_equal @simple.process_status, "imported"
    assert_equal @simple.leads_imported, 1
    assert_equal @simple.leads_updated, 1

    lead = leads.last

    assert_equal lead.name, "Jônatas Davi Paganini"
    assert_equal lead.lead_info.twitter, "jonatasdp"

  end
end
