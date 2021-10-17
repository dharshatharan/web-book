FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Name.first_name }
    password { Faker::Internet.password(min_length: 10, max_length: 20) }
    display_name { Faker::Name.name }
    role { "public" }
    avatar { Rack::Test::UploadedFile.new("assets/avatar.png", "avatar.png") }
  end
end
