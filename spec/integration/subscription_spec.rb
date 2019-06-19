require 'rails_helper'
RSpec.describe 'Event Subscription - hook into main system' do
  it 'enqueues the correct worker class' do
    #  Arrange - Setup input data
    claim = build(:claim)
    system = build(:external_system, :ccd, :for_all_offices)
    export = build(:export, external_system: system, resource: claim)
    
    # Act - publish the event as the application would
    Rails.application.event_service.publish('ClaimQueuedForExport', export)
    
    # Assert - Ensure the correct class is used
    expect(Sidekiq::Worker.jobs).to include a_hash_including 'class' => '::EtExporter::ExportClaimWorker'
  end
  
  it 'provides the correct json as the argument' do
    #  Arrange - Setup input data
    claim = build(:claim)
    system = build(:external_system, :ccd)
    export = build(:export, external_system: system, resource: claim)

    # Act - publish the event as the application would
    Rails.application.event_service.publish('ClaimQueuedForExport', export)
    
    # Assert - Ensure the json data matches the schema
    expect(Sidekiq::Worker.jobs.first['args'].first).to match_json_schema('exported_claim')
  end
  
  
end
