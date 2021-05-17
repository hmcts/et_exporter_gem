require 'sidekiq'
module EtExporter
  class ClaimFilesAddedHandler
    def handle(export, files, event_service: Rails.application.event_service)
      json = EtExporter::ApplicationController.render('et_exporter/v1/update_claim/files_added', locals: { files: files, export: export, system: export.external_system }, formats: [:json])
      jid = client_push('class' => '::EtExporter::ExportClaimUpdateWorker', 'args' => [json], 'queue' => export.external_system.export_queue)
      event_data = {
        sidekiq: {
          jid: jid,
          bid: nil,
        },
        export_id: export.id,
        external_data: export.external_data,
        state: 'queued',
        percent_complete: 0,
        message: 'Queued for export from API'
      }
      event_service.publish('ClaimExportFeedbackReceived', event_data.to_json)
    end
    
    def client_push(item)
      Sidekiq::Client.new(Sidekiq.redis_pool).push(item)
    end
  end
end
