FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name}
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    verified_at { Time.now }

    trait :admin do
      is_admin { true }
      role { :admin }
    end

    trait :merchant do
      role { :merchant }
    end

  end
end