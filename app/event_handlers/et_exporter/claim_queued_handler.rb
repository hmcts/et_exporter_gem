require 'sidekiq'
module EtExporter
  class ClaimQueuedHandler
    def handle(export, event_service: Rails.application.event_service)
      json = EtExporter::ApplicationController.render('et_exporter/v1/export_claim/export.json.jbuilder', locals: {claim: export.resource, export: export, system: export.external_system})
      jid = client_push('class' => '::EtExporter::ExportClaimWorker', 'args' => [json], 'queue' => export.external_system.export_queue)
      event_data = {
        sidekiq: {
          jid: jid,
          bid: nil,
        },
        export_id: export.id,
        external_data: {},
        state: 'queued',
        percent_complete: nil
      }
      event_service.publish('ClaimExportFeedbackReceived', event_data.to_json)
    end
    
    def client_push(item)
      Sidekiq::Client.new(Sidekiq.redis_pool).push(item)
    end
  end
end
