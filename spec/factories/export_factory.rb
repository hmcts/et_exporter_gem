FactoryBot.define do
  factory :export do
    association :resource
    association :external_system
  end
end
