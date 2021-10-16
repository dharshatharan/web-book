FactoryBot.define do
  factory :user do
    email { "MyString" }
    password { "MyString" }
    role { "MyString" }
    username { "" }
    display_name { "MyString" }
    personal_website { "" }
    avatar { nil }
  end
end
