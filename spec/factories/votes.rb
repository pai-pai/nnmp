# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    user nil
    candidate nil
    comment "MyString"
    voter_fio "MyString"
    voter_phone "MyString"
  end
end
