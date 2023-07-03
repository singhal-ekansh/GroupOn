FactoryBot.define do
  factory :image do
    file { Rack::Test::UploadedFile.new('spec/fixtures/swiggy1.jpeg', 'image/png') }
  end
end