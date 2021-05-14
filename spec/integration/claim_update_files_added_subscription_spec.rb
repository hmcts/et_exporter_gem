require 'rails_helper'
RSpec.describe 'Claim Update - Adding Files Event Subscription - hook into main system' do
  before { Sidekiq::Worker.clear_all }


  context 'A claim update with additional files being added' do
    let(:claim) { create(:claim, :default, :with_pdf_file) }
    let(:system) { build(:external_system, :ccd) }
    let(:export) { create(:export, external_system: system, resource: claim) }
    let!(:extra_files) do
      [create(:uploaded_file, :example_acas_pdf)].tap do |files|
        claim.uploaded_files << files
      end
    end

    it 'enqueues the correct worker class' do

      # Act - publish the event as the application would
      Rails.application.event_service.publish('ExportedClaimFilesAdded', export, extra_files)

      # Assert - Ensure the correct class is used
      expect(Sidekiq::Worker.jobs).to include a_hash_including 'class' => '::EtExporter::ExportClaimUpdateWorker'
    end


    it 'provides json matching the schema as the single argument' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ExportedClaimFilesAdded', export, extra_files)

      # Assert - Ensure the json data matches the schema
      expect(Sidekiq::Worker.jobs.first['args'].first).to match_json_schema('updated_claim')
    end
  end



  context 'A claim with a multiple partial claimants from spreadsheet, single respondent and representative.  With employment details' do
    let(:claim) { create(:claim, :default, number_of_claimants: 2, secondary_claimant_traits: [:minimal]) }
    let(:system) { build(:external_system, :ccd) }
    let(:export) { create(:export, external_system: system, resource: claim) }
    it 'provides json matching the schema as the single argument' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)

      # Assert - Ensure the json data matches the schema
      expect(Sidekiq::Worker.jobs.first['args'].first).to match_json_schema('exported_claim')
    end

    it 'has 1 secondary claimants and no secondary respondents' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)

      # Assert - Ensure the json is correct
      aggregate_failures 'validate secondaries' do
        expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first).dig('resource', 'secondary_claimants').length).to be 1
        expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first).dig('resource', 'secondary_respondents').length).to be 0
      end
    end
  end
end
