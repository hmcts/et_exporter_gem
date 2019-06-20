require 'sidekiq'
module EtExporter
  class ClaimQueuedHandler
    def handle(export)
      json = EtExporter::ApplicationController.render('et_exporter/v1/export_claim/export.json.jbuilder', locals: {claim: export.resource, export: export, system: export.external_system})
      client_push('class' => '::EtExporter::ExportClaimWorker', 'args' => [json], 'queue' => export.external_system.export_queue)
    end
    
    def client_push(item)
      Sidekiq::Client.new(Sidekiq.redis_pool).push(item)
    end
  end
end
