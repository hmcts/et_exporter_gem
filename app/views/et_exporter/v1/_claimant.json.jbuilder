json.(claimant, :first_name, :last_name, :address_telephone_number, :contact_preference, :date_of_birth, :email_address, :fax_number)
json.(claimant, :gender, :mobile_number, :special_needs, :title)
json.address do
  json.partial! "et_exporter/v1/address.json.jbuilder", address: claimant.address
end
