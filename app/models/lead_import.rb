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

      lead.lead_info.save if  lead.lead_info.some_info_filled?
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
    lead.lead_info ||= LeadInfo.new lead: lead

    process_twitter lead.lead_info, hash
    process_facebook lead.lead_info, hash
    process_linkedin lead.lead_info, hash
    process_website lead.lead_info, hash
    process_mobile_phone lead.lead_info, hash
    process_city lead, hash
    process_state lead, hash
    process_available_for_mailing lead, hash
    process_opportunity lead, hash

  end

  def process_twitter lead_info, hash
    if (twitter = hash["twitter"] || hash["Twitter"])
      if !twitter.blank? && lead_info.twitter.blank?
        twitter = twitter[1..-1] if twitter.starts_with? "@"
        lead_info.twitter ||= twitter
      end
    end
  end

  def process_facebook lead_info, hash
    if (facebook = hash["facebook"] || hash["Facebook"])
      if !facebook.blank? && lead_info.facebook.blank?
        if facebook !~ %r{^https?://(www\.)?facebook.com/}
          facebook = "https://facebook.com/#{facebook}"
        end
        lead_info.facebook ||= facebook
      end
    end
  end

  def process_linkedin lead_info, hash
    if (linkedin = hash["linkedin"] || hash["Linkedin"])
      if !linkedin.blank? && lead_info.linkedin.blank?
        if linkedin !~ %r{^https?://(www\.)?linkedin.com/in/}
          linkedin = "https://www.linkedin.com/in/#{linkedin}"
        end
        lead_info.linkedin ||= linkedin
      end
    end
  end

  def process_website lead_info, hash
    if (website = hash["website"] || hash["Website"] || hash["site"] || hash["Site"])
      if !website.blank? && lead_info.website.blank?
        if website !~ %r{^https?:///}
          website = "http://#{website}"
        end
        lead_info.website ||= website
      end
    end
  end

  def process_mobile_phone lead_info, hash
    if (mobile_phone = 
        hash["Celular"]  || hash["celular"] ||
        hash["Telefone"] || hash["telefone"] ||
        hash["Phone"]    || hash['phone'] ||
        hash["Mobile Phone"] || hash['mobile phone'])

      if !mobile_phone.blank? && lead_info.mobile_phone.blank?
        lead_info.mobile_phone ||= mobile_phone.tr(")( -",'')
      end
    end
  end

  def process_city lead, hash
    if (city = hash["city"] || hash["City"])
      if !city.blank? && lead.city.blank?
        lead.city = City.find_or_create_by(name: city)
      end
    end
  end

  def process_state lead, hash
    if (state = hash["state"] || hash["State"])
      if !state.blank? && lead.state.blank?
        where = 
          if state.length == 2
            lead.state ||= State.find_or_create_by acronym: state.upcase
          else
            lead.state ||= State.find_or_initialize_by name: state
          end
      end
    end
  end


  def process_available_for_mailing lead, hash
    if (available_for_mailing =
        hash["available_for_mailing"] || hash["Available for mailing"] ||
        hash["disponivel_para_email"] || hash["Disponível para email"])

      lead.available_for_mailing = process_boolean(available_for_mailing)
    end
  end

  def process_opportunity lead, hash
    if (opportunity = hash["opportunity"] || hash["Oportunidade"])
      processed = process_boolean(opportunity)
      if !processed.nil?
        lead.opportunity = processed
      end
    end
  end

  def row_to_hash row
    info = {}
    row.each_with_index{|e,i| info[@header[i]] = row[i]}
    info
  end

  def process_boolean text
    return nil unless text
    if text =~ /^(0|n[aã]?o?)$/i
      false
    elsif text =~ /^(1|y(es)?|s(im)?)$/i
      true
    else
      raise "Can't convert #{text.inspect} to boolean"
    end
  end
end
