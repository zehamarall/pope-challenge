require "csv"
class LeadImport < ActiveRecord::Base
  validates :file, presence: true, uniqueness: true

  def lines
    CSV.read(file)
  end

  def import!
    @header = lines[0]
    self.leads_imported = 0
    self.leads_updated = 0
    leads = []
    lines[1..-1].each do |line|
      email_columns = @header.grep(/\s?email$/i)
      lead = nil

      email_columns.each do |email_column|
        i = @header.index email_column
        email_info = line[i]
        lead = Lead.find_or_initialize_by(email: email_info.strip.downcase)
        break unless lead.new_record?
      end

      if not lead
        update_attributes process_status: "invalid file: email information missing"
        return
      end

      process_info lead, line

      if lead.persisted?
        update_attribute :leads_updated, self.leads_updated + 1
      else
        update_attribute :leads_imported, self.leads_imported + 1
      end

      lead.save
      leads.push lead
    end

    update_attributes process_status: "imported"
    leads
  end

  def process_info lead, row
    hash = row_to_hash(row)
    name = hash["Nome"] || hash["Name"] || hash["Full Name"] || hash["First Name"]
    lead.name = name unless name.blank?

    if twitter = hash["twitter"] || hash["Twitter"]
      lead.lead_info ||= LeadInfo.new
      twitter = twitter[1..-1] if twitter.starts_with? "@"
      lead.lead_info.twitter = twitter
    end
    lead
  end

  def row_to_hash row
    info = {}
    row.each_with_index{|e,i| info[@header[i]] = row[i]}
    info
  end
end
