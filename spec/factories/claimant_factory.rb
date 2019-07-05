FactoryBot.define do
  factory :claimant do
    trait :default do
      minimal
      address_telephone_number { '01234 567890' }
      mobile_number { '01234 098765' }
      email_address { 'test@digital.justice.gov.uk' }
      contact_preference { 'Email' }
      gender { 'Male' }
      special_needs { 'My special needs are as follows' }
      fax_number { '01234 123456' }
    end

    trait :minimal do
      title { "Mr" }
      first_name { "Paul" }
      sequence(:last_name) { |idx| "O'Malley#{idx}" }
      association :address,
                  building: '102',
                  street: 'Petty France',
                  locality: 'London',
                  county: 'Greater London',
                  post_code: 'SW1H 9AJ'
      date_of_birth { Date.parse('21/11/1982') }
    end

    trait :with_uk_country do
      association :address,
                  building: '102',
                  street: 'Petty France',
                  locality: 'London',
                  county: 'Greater London',
                  post_code: 'SW1H 9AJ',
                  country: 'United Kingdom'
    end

  end
end
