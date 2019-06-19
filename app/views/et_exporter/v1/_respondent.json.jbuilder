json.(respondent, :name, :acas_certificate_number, :acas_exemption_code)
json.(respondent, :address_telephone_number, :alt_phone_number, :contact, :contact_preference)
json.(respondent,  :disability, :disability_information, :dx_number, :email_address, :employment_at_site_number, :fax_number)
json.(respondent, :organisation_employ_gb, :organisation_more_than_one_site, :work_address_telephone_number)
json.address do
  json.partial! "et_exporter/v1/address.json.jbuilder", address: respondent.address
end
if respondent.work_address.present?
  json.work_address do
    json.partial! "et_exporter/v1/address.json.jbuilder", address: respondent.work_address
  end
else
  json.work_address nil
end

