FactoryGirl.define do
  factory :simple_import, class: LeadImport do
    file "test/data/simple_import.csv" 
  end
end
puts "defined factories" 
