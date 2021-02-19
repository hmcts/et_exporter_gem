require 'sidekiq'
module EtExporter
  class ResponseQueuedHandler
    def handle(export)
      json = EtExporter::ApplicationController.render('et_exporter/v1/export_response/export', locals: {response: export.resource, export: export, system: export.external_system}, formats: [:json])
      client_push('class' => '::EtExporter::ExportResponseWorker', 'args' => [json], 'queue' => export.external_system.export_queue)
    end
    
    def client_push(item)
      Sidekiq::Client.new(Sidekiq.redis_pool).push(item)
    end
  end
end
