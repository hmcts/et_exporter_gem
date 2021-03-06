json.external_system do
  json.name system.name
  json.reference system.reference
  json.enabled system.enabled
  json.office_codes system.office_codes
  json.export_feedback_queue system.export_feedback_queue
  json.configurations do
    json.array! system.configurations do |configuration|
      json.key configuration.key
      json.value configuration.value
    end
  end
end
