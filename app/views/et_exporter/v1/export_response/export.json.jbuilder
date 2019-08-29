json.resource_type 'Response'
json.partial! "/et_exporter/v1/external_system.json.jbuilder", system: system
json.resource do
  json.partial! "/et_exporter/v1/response.json.jbuilder", response: response
end
