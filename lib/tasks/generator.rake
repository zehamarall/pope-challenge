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

  desc "rake gen:csv[1000] to export N leads from database to a csv"
  task "csv", [:size] => :environment do |t,params|

    size = params[:size].to_i || 1000
    CSV.open("/tmp/ram/leads.csv", "w+") do |csv|
      csv << %w(Email Nome Twitter Website Facebook Linkedin Phone City State Tags Opportunity Job\ Title Available\ for\ mailing)
        Lead.limit(size).with_progress("exporting #{Lead.count} leads").each do |lead|
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
