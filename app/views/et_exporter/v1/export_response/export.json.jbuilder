json.id export.id
json.resource_type 'Response'
json.partial! "/et_exporter/v1/external_system", system: system, formats: [:json]
json.resource do
  json.partial! "/et_exporter/v1/response", response: response, formats: [:json]
end
