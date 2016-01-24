FactoryGirl.define do

  sequence :job_title do |n|
    "Lead worker #{n}"
  end
  sequence :email do |n|
     email = [Faker::Internet.safe_email, Faker::Internet.email, Faker::Internet.free_email].sample
     user,domain = email.split("@")
     [user,n,"@",domain].join ""
  end

  factory :lead, class: Lead do
    name Faker::Name.name
    email { generate(:email) }
    job_title { generate(:job_title) }
    opportunity { [true,false].sample }
    available_for_mailing { [true,false].sample }
    company factory: :random_company
    city factory: :random_city
    state { State.first || factory(:random_state) }
    lead_info factory: :random_lead_info
  end

  factory :random_city, class: City do
    name { Faker::Address.city << rand(Time.now.to_i).to_s }
  end

  factory :random_state, class: State do
    acronym { Faker::Address.state_abbr[0,2] }
    name { Faker::Address.state << rand(Time.now.to_i).to_s }
  end

  factory :random_company, class: Company do
    name { Faker::Company.name << rand(Time.now.to_i).to_s }
    twitter { Faker::Internet.user_name }
    facebook { Faker::Internet.user_name }
    address { Faker::Address.street_address }
    email { Faker::Internet.safe_email }
    site { [Faker::Internet.url,Faker::Internet.domain_name].sample }
    phone { Faker::PhoneNumber.cell_phone }
  end

  factory :random_lead_info, class: LeadInfo do
    linkedin { Faker::Internet.user_name }
    twitter { Faker::Internet.user_name }
    facebook { Faker::Internet.user_name }
    website { [Faker::Internet.url,Faker::Internet.domain_name].sample }
    mobile_phone { Faker::PhoneNumber.cell_phone }
    personal_phone { Faker::PhoneNumber.cell_phone }
  end
end
