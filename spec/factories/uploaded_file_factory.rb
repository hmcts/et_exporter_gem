FactoryBot.define do
  factory :uploaded_file do
    transient do
      upload_method { :url }
      file_to_attach { nil }
    end
    
    trait :example_pdf do
      filename { 'et1_first_last.pdf' }
      checksum { 'ee2714b8b731a8c1e95dffaa33f89728' }
      file_to_attach { { content_type: 'application/pdf', filename: File.absolute_path('../fixtures/example.pdf', __dir__) } }
    end

    trait :example_claim_rtf do
      filename { 'et1_attachment_first_last.rtf' }
      checksum { 'ee2714b8b731a8c1e95dffaa33f89728' }
      file_to_attach { { content_type: 'application/rtf', filename: File.absolute_path('../fixtures/example.rtf', __dir__) } }
    end

    trait :example_claim_claimants_csv do
      filename { 'et1a_first_last.csv' }
      checksum { 'ee2714b8b731a8c1e95dffaa33f89728' }
      file_to_attach { { content_type: 'text/csv', filename: File.absolute_path('../fixtures/example.csv', __dir__) } }
    end

    trait :direct_upload do
      upload_method { :direct_upload }
    end

    after(:build) do |uploaded_file, evaluator|
      next if evaluator.file_to_attach.nil?
      attrs = evaluator.file_to_attach.clone
      attrs[:io] = File.open(attrs[:filename], 'r')
      attrs[:filename] = File.basename(attrs[:filename])
      uploaded_file.file = attrs
      uploaded_file.save
    ensure
      attrs[:io].close unless attrs[:io].nil?
    end
  end
end
