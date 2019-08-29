require 'rails_helper'
RSpec.describe 'Response Event Subscription - hook into main system' do
  before { Sidekiq::Worker.clear_all }

  it 'enqueues the correct worker class' do
    #  Arrange - Setup input data
    response = build(:response, :default)
    system = build(:external_system, :ccd, :for_all_offices)
    export = build(:export, external_system: system, resource: response)

    # Act - publish the event as the application would
    Rails.application.event_service.publish('ResponseQueuedForExport', export)

    # Assert - Ensure the correct class is used
    expect(Sidekiq::Worker.jobs).to include a_hash_including 'class' => '::EtExporter::ExportResponseWorker'
  end

  context 'A response with a respondent and no representative' do
    let(:response) { build(:response, :default) }
    let(:system) { build(:external_system, :ccd) }
    let(:export) { build(:export, external_system: system, resource: response) }
    it 'provides json matching the schema as the single argument' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ResponseQueuedForExport', export)

      # Assert - Ensure the json data matches the schema
      expect(Sidekiq::Worker.jobs.first['args'].first).to match_json_schema('exported_response')
    end

    it 'has a nil representative' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ResponseQueuedForExport', export)

      # Assert - Ensure the json data matches the schema
      expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first).dig('resource', 'representative')).to be_nil
    end
  end

  context 'A response with a respondent and a representative' do
    let(:response) { build(:response, :default, :with_representative) }
    let(:system) { build(:external_system, :ccd) }
    let(:export) { build(:export, external_system: system, resource: response) }
    it 'provides json matching the schema as the single argument' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ResponseQueuedForExport', export)

      # Assert - Ensure the json data matches the schema
      expect(Sidekiq::Worker.jobs.first['args'].first).to match_json_schema('exported_response')
    end

    it 'has a representative' do
      # Act - publish the event as the application would
      Rails.application.event_service.publish('ResponseQueuedForExport', export)

      # Assert - Ensure the json data matches the schema
      expect(JSON.parse(Sidekiq::Worker.jobs.first['args'].first).dig('resource', 'representative')).to be_present
    end

  end
end
