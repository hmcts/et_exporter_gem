FactoryBot.define do
  factory :export do
    sequence(:id) {|idx| idx}
    association :resource
    association :external_system
  end
end
