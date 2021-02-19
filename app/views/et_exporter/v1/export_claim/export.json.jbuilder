json.id export.id
json.resource_type 'Claim'
json.partial! "/et_exporter/v1/external_system", system: system, formats: [:json]
json.resource do
  json.partial! "/et_exporter/v1/claim", claim: claim, formats: [:json]
end
