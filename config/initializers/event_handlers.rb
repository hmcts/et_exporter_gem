Rails.application.config.after_initialize do |app|
  app.event_service.subscribe('ClaimQueuedForExport', EtExporter::ClaimQueuedHandler, async: false, in_process: true)
end
