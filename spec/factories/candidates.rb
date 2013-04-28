# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :candidate do
    fam_name "MyString"
    first_name "MyString"
    sec_name "MyString"
    nomination nil
    org nil
    unit nil
    depart "MyString"
    ward "MyString"
  end
end
