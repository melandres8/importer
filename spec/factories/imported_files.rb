FactoryBot.define do
  factory :imported_file do
    filename { "MyString" }
    error_msg { "MyString" }
    user { nil }
  end
end
