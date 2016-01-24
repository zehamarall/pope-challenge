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

  test "process boolean" do
    assert_nil @simple.process_boolean(nil)

    assert @simple.process_boolean("sim")
    assert @simple.process_boolean("Sim")
    assert @simple.process_boolean("yes")
    assert @simple.process_boolean("YES")
    assert @simple.process_boolean("Y")
    assert @simple.process_boolean("1")

    assert_not @simple.process_boolean("0")
    assert_not @simple.process_boolean("Não")
    assert_not @simple.process_boolean("não")
    assert_not @simple.process_boolean("n")
    assert_not @simple.process_boolean("no")
    assert_not @simple.process_boolean("NO")


  end
  test "import and update info when info is not blank." do
    leads = nil
    assert_difference "Lead.count", 1 do
      leads = @simple.import!
    end

    assert_equal @simple.process_status, "imported"
    assert_equal @simple.leads_imported, 1, "import just once"
    assert_equal @simple.leads_updated, @simple.lines.length - 2, "updates the same lead with all info"

    lead = leads.last

    assert_equal lead.name, "Jônatas Davi Paganini"
    assert_equal lead.lead_info.twitter, "jonatasdp", 'it removes @ if exists'
    assert_equal lead.lead_info.facebook, "https://facebook.com/jonatas.paganini", "should adjust if passed only username"
    assert_equal lead.lead_info.linkedin, "https://www.linkedin.com/in/jonatasdp" 
    assert_equal lead.lead_info.website, "http://ideia.me", "inserts protocols http:// if was forgotten"
    assert_equal lead.lead_info.mobile_phone, "4896378119", "keeps just numbers"
    assert_equal lead.city.name, "Florianópolis"
    assert_equal lead.state.acronym, "SC"
    assert lead.available_for_mailing, "should parse 1,0,yes,no to true or false"
    assert_not lead.opportunity, "should parse opportunity 1,0,yes,no to true or false"
  end
end
