FactoryBot.define do
  factory :deal do
    title { Faker::Name.first_name }
    description { Faker::Lorem.paragraph  }
    price { Faker::Number.between(from: 1, to: 1000) }
    start_at { 2.days.from_now }
    expire_at { 4.days.from_now }
    threshold_value { 500 }
    total_availaible { 1000 }
    max_per_user { Faker::Number.between(from: 1, to: 1000) }
    category_id { create(:category).id }
    merchant_id { create(:user, :merchant).id }
    
    trait :admin do
      user_id { create(:user, :admin).id }
    end

    trait :published do
      published { true }
      locations { [build(:location)] }
      images { [build(:image)] }
    end

    trait :valid do
      locations { [build(:location)] }
      images { [build(:image)] }
    end

    trait :live do
      start_at { Date.today }
    end

  end
end