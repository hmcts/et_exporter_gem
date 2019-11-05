require 'rails_helper'
RSpec.describe ::EtExporter::ClaimExportFeedbackReceivedHandler do
  subject(:handler) { described_class.new }
  let(:claim) { create(:claim, :default) }
  let(:system) { build(:external_system, :ccd) }

  it 'adds an event with a status, percent_complete and message matching that given' do
    # Arrange - Create an example export
    export = create(:export, external_system: system, resource: claim)
    example_data = {
      'export_id' => export.id,
      'sidekiq' => {
        'jid' => 'examplejid'
      },
      'external_data' => {},
      'state' => 'in_progress',
      'percent_complete' => 12,
      'message' => 'Still ongoing'
    }

    # Act - call the handler
    handler.handle(example_data.to_json)

    # Assert - Ensure an event has been added
    expect(ExportEvent.where(export: export, state: 'in_progress', percent_complete: 12, message: 'Still ongoing').count).to be 1
  end

  it 'changes the status only if required' do
    # Arrange - Create an example export
    export = create(:export, external_system: system, resource: claim)
    example_data = {
      'export_id' => export.id,
      'sidekiq' => {
        'jid' => 'examplejid'
      },
      'external_data' => {},
      'state' => 'in_progress'
    }

    # Act - call the handler
    handler.handle(example_data.to_json)

    # Assert - Ensure an event has been added
    expect(ExportEvent.where(export: export, state: 'in_progress').count).to be 1
  end

  it 'sets the state, percent_complete and message to what was given' do
    # Arrange - Create an example export
    export = create(:export, external_system: system, resource: claim)
    example_data = {
      'export_id' => export.id,
      'sidekiq' => {
        'jid' => 'examplejid'
      },
      'external_data' => {},
      'state' => 'in_progress',
      'percent_complete' => 12,
      'message' => 'Still ongoing'
    }

    # Act - call the handler
    handler.handle(example_data.to_json)

    # Assert - Ensure an event has been added
    expect(Export.find(export.id)).to have_attributes state: "in_progress", percent_complete: 12, message: 'Still ongoing'
  end

  it 'records the sidekiq jid in the data' do
    # Arrange - Create an example export
    export = create(:export, external_system: system, resource: claim)
    example_data = {
      'export_id' => export.id,
      'sidekiq' => {
        'jid' => 'examplejid'
      },
      'external_data' => {},
      'state' => 'in_progress',
      'percent_complete' => 0,
      'message' => 'Still ongoing'
    }

    # Act - call the handler
    handler.handle(example_data.to_json)

    # Assert - Ensure an event has been added
    expect(ExportEvent.where(export: export, state: 'in_progress').first.data['sidekiq']).to include 'jid' => 'examplejid'
  end

  it 'merges the ccd data in the data of the export' do
    # Arrange - Create an example export
    export = create(:export, external_system: system, resource: claim, external_data: { 'test' => 'data' })
    example_data = {
      'export_id' => export.id,
      'sidekiq' => {
        'jid' => 'examplejid'
      },
      'external_data' => {
        'case_id' => 'examplecaseid',
        'case_type_id' => 'examplecasetypeid'
      },
      'state' => 'in_progress',
      'percent_complete' => 0,
      'message' => 'Still ongoing'
    }

    # Act - call the handler
    handler.handle(example_data.to_json)

    # Assert - Ensure an event has been added
    expect(Export.find(export.id).external_data).to include 'case_id' => 'examplecaseid', 'case_type_id' => 'examplecasetypeid', 'test' => 'data'
  end
end
