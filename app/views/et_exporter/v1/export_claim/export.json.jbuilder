json.id export.id
json.resource_type 'Claim'
json.partial! "/et_exporter/v1/external_system.json.jbuilder", system: system
json.resource do
  json.partial! "/et_exporter/v1/claim.json.jbuilder", claim: claim
end
