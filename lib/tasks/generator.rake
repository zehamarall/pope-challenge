require "csv"

namespace "gen" do


  desc "rake gen:leads[100] to create 100 random leads"
  task "leads", [:size] => :environment do |t,params|
    require File.expand_path('../../../test/factories/random', __FILE__)
    include FactoryGirl::Syntax::Methods

    size = params[:size].to_i || 1000
    size.times_with_progress("creating #{size} leads") do |i|
      print "."
      create(:lead) 
    end
  end

  desc "rake gen:csv[100] to create 100 random leads in a csv"
  task "csv", [:size] => :environment do |t,params|

    CSV.open("leads.csv", "w+") do |csv|
      csv << %w(Email Nome Twitter Website Facebook Linkedin Phone City State Tags Opportunity Job\ Title Available\ for\ mailing)
        Lead.all.with_progress("exporting #{Lead.count} leads").each do |lead|
          csv << [lead.email, 
                  lead.name,
                  lead.lead_info.twitter,
                  lead.lead_info.website,
                  lead.lead_info.facebook,
                  lead.lead_info.linkedin,
                  lead.lead_info.mobile_phone,
                  lead.city.try(:name),
                  lead.state.try(:acronym),
                  lead.tags,
                  lead.opportunity ? 1 : 0,
                  lead.job_title,
                  lead.available_for_mailing ? 1 : 0]
        end
      end
    end
end
=begin

      lead = Lead.create name: Faker::Name.name,
        email: [Faker::Internet.safe_email, Faker::Internet.email, Faker::Internet.free_email].sample,
        job_title: "Lead worker #{i}",
        opportunity: [true,false].sample,
        available_for_mailing: [true,false].sample,
        city: City.find_or_create_by(name: Faker::Address.city),
        state: State.find_or_create_by(acronym: Faker::Address.state_abbr[0,2], name: Faker::Address.state),
        company: Company.find_or_create_by(
          name: Faker::Company.name,
          twitter: Faker::Internet.user_name,
          facebook: Faker::Internet.user_name,
          address: Faker::Address.street_address,
          email: Faker::Internet.safe_email,
          site: [Faker::Internet.url,Faker::Internet.domain_name].sample,
          phone: Faker::PhoneNumber.cell_phone
        )

      LeadInfo.create lead: lead,
        twitter: Faker::Internet.user_name,
        facebook: Faker::Internet.user_name,
        linkedin: Faker::Internet.user_name,
        mobile_phone: Faker::PhoneNumber.cell_phone,
        personal_phone: Faker::PhoneNumber.cell_phone,
        website: [Faker::Internet.url,Faker::Internet.domain_name].sample
        
    end
  end
=end