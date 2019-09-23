Rails.application.config.after_initialize do |app|
  app.event_service.subscribe('ClaimQueuedForExport', EtExporter::ClaimQueuedHandler, async: false, in_process: true)
  app.event_service.subscribe('ResponseQueuedForExport', EtExporter::ResponseQueuedHandler, async: false, in_process: true)
end
