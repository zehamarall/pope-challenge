FactoryGirl.define do
  factory :simple_import, class: LeadImport do
    file "test/data/simple_import.csv" 
  end
  factory :simple_import_with_more_info, class: LeadImport do
    file "test/data/simple_with_name.csv"
  end
end
