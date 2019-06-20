FactoryBot.define do
  factory :external_system do

    trait :atos do
      name { "Atos" }
      reference { "atos" }
      office_codes { [] }
      enabled { true }
      export { false }
    end

    trait :minimal do
      name { "Anything" }
      sequence(:reference) { |idx| "reference#{idx}" }
      office_codes { [] }
      enabled { true }
      export { false }
    end
    
    trait :ccd do
      name { "CCD" }
      reference { "ccd_manchester" }
      office_codes { [] }
      enabled { true }
      export { true }
      export_queue { 'external_system_ccd' }
      configurations do
        [
            build(:external_system_configuration, key: 'key1', value: 'value1'),
            build(:external_system_configuration, key: 'key2', value: 'value2')
        ]
      end
    end

    trait :for_all_offices do
      office_codes { [1,2,3,4,5,6,7,8,9,10,99] }
    end
  end
end
