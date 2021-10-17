FactoryBot.define do
  factory :website do
    domain { Faker::Internet.domain_name(subdomain: true) }
    url { Faker::Internet.url }
  end
end
