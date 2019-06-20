require 'rails_helper'
RSpec.describe 'Event Subscription - hook into main system' do
  before { Sidekiq::Worker.clear_all }
  
  it 'enqueues the correct worker class' do
    #  Arrange - Setup input data
    claim = build(:claim, :default)
    system = build(:external_system, :ccd, :for_all_offices)
    export = build(:export, external_system: system, resource: claim)
    
    # Act - publish the event as the application would
    Rails.application.event_service.publish('ClaimQueuedForExport', export)
    
    # Assert - Ensure the correct class is used
    expect(Sidekiq::Worker.jobs).to include a_hash_including 'class' => '::EtExporter::ExportClaimWorker'
  end
  
  context 'A claim with a single claimant, respondent and representative.  With employment details' do
    let(:claim) { build(:claim, :default) }
    let(:system) { build(:external_system, :ccd) }
    let(:export) { build(:export, external_system: system, resource: claim) }
    it 'provides json matching the schema as the single argument' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
      
      # Assert - Ensure the json data matches the schema
      expect(Sidekiq::Worker.jobs.first['args'].first).to match_json_schema('exported_claim')
    end

    it 'has no secondary claimants and no secondary respondents' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
  
      # Assert - Ensure the json is correct
      aggregate_failures 'validate secondaries' do
        expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first).dig('resource', 'secondary_claimants').length).to be 0
        expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first).dig('resource', 'secondary_respondents').length).to be 0
      end
    end

    it 'has a primary_representative' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
  
      # Assert - Ensure the json data matches the schema
      expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first).dig('resource', 'primary_representative')).to be_present
    end
  end

  # Vary the respondents
  context 'A claim with a single claimant, 2 respondents and a representative.  With employment details' do
    let(:claim) { build(:claim, :default, number_of_respondents: 2) }
    let(:system) { build(:external_system, :ccd) }
    let(:export) { build(:export, external_system: system, resource: claim) }
    it 'provides json matching the schema as the single argument' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
      
      # Assert - Ensure the json data matches the schema
      expect(Sidekiq::Worker.jobs.first['args'].first).to match_json_schema('exported_claim')
    end

    it 'has no secondary claimants and 1 secondary respondents' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
  
      # Assert - Ensure the json is correct
      aggregate_failures 'validate secondaries' do
        expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first).dig('resource', 'secondary_claimants').length).to be 0
        expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first).dig('resource', 'secondary_respondents').length).to be 1
      end
    end
  end
  
  # Vary the representative
  context 'A claim with a single claimant, a respondent and no representative.  With employment details' do
    let(:claim) { build(:claim, :default, has_representative: false) }
    let(:system) { build(:external_system, :ccd) }
    let(:export) { build(:export, external_system: system, resource: claim) }
    it 'provides json matching the schema as the single argument' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
      
      # Assert - Ensure the json data matches the schema
      expect(Sidekiq::Worker.jobs.first['args'].first).to match_json_schema('exported_claim')
    end

    it 'has a nil primary_representative' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
      
      # Assert - Ensure the json data matches the schema
      expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first).dig('resource', 'primary_representative')).to be nil
    end
  end

  # Vary the claimants
  context 'A claim with a multiple claimants, single respondent and representative.  With employment details' do
    let(:claim) { build(:claim, :default, number_of_claimants: 2) }
    let(:system) { build(:external_system, :ccd) }
    let(:export) { build(:export, external_system: system, resource: claim) }
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

  # Vary the employment details
  context 'A claim with a single claimant, respondent and representative.  Without employment details' do
    let(:claim) { build(:claim, :default, :without_employment_details) }
    let(:system) { build(:external_system, :ccd) }
    let(:export) { build(:export, external_system: system, resource: claim) }
    it 'provides json matching the schema as the single argument' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
    
      # Assert - Ensure the json data matches the schema
      expect(Sidekiq::Worker.jobs.first['args'].first).to match_json_schema('exported_claim')
    end
    
    it 'has no secondary claimants or respondents' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
  
      # Assert - Ensure the json is correct
      expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first)['resource']).to include 'secondary_claimants' => [], 'secondary_respondents' => []
    end
  end

  context 'A claim with a single claimant, respondent and representative.  With employment details - working notice period' do
    let(:claim) { build(:claim, :default, :with_employment_details_notice_period) }
    let(:system) { build(:external_system, :ccd) }
    let(:export) { build(:export, external_system: system, resource: claim) }
    it 'provides json matching the schema as the single argument' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
    
      # Assert - Ensure the json data matches the schema
      expect(Sidekiq::Worker.jobs.first['args'].first).to match_json_schema('exported_claim')
    end
    
    it 'has no secondary claimants or respondents' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
  
      # Assert - Ensure the json is correct
      expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first)['resource']).to include 'secondary_claimants' => [], 'secondary_respondents' => []
    end
  end

  context 'A claim with a single claimant, respondent and representative.  With employment details - terminated' do
    let(:claim) { build(:claim, :default, :with_employment_details_terminated) }
    let(:system) { build(:external_system, :ccd) }
    let(:export) { build(:export, external_system: system, resource: claim) }
    it 'provides json matching the schema as the single argument' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
    
      # Assert - Ensure the json data matches the schema
      expect(Sidekiq::Worker.jobs.first['args'].first).to match_json_schema('exported_claim')
    end
    
    it 'has no secondary claimants or respondents' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ClaimQueuedForExport', export)
  
      # Assert - Ensure the json is correct
      expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first)['resource']).to include 'secondary_claimants' => [], 'secondary_respondents' => []
    end
  end

end
