FactoryBot.define do
  factory :location do
    address { Faker::Address.full_address}
    state { Faker::Address.state }
    country { Faker::Address.country }
    city { Faker::Address.city }
    pincode { Faker::Address.zip_code }
  end
end