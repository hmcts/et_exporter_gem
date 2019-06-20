json.(representative, :name, :organisation_name, :address_telephone_number, :mobile_number, :email_address)
json.(representative, :representative_type, :dx_number, :reference, :contact_preference, :fax_number)
json.address do
  json.partial! "et_exporter/v1/address.json.jbuilder", address: representative.address
end
