FactoryBot.define do
  factory :contact do
    sequence(:name) { |n| "Contact Name #{n}" }
    birthdate { '2020-05-15' }
    phone { '(+57) 317-730-71-72' }
    address { 'My Address' }
    credit_card { '5274576394259961' }
    four_digits { '9961' }
    franchise { 'MasterCard' }
    sequence(:email) { |n| "email#{n}@email.com" }
    association :user
  end
end
