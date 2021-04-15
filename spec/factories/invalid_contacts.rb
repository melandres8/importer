FactoryBot.define do
  factory :invalid_contact do
    name { "MyString" }
    birthdate { "MyString" }
    phone { "MyString" }
    address { "MyString" }
    credit_card { "MyString" }
    franchise { "MyString" }
    four_digits { "MyString" }
    error_msg { "MyString" }
    email { "MyString" }
    user { nil }
  end
end
