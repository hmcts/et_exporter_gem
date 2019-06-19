json.(claim, :reference, :case_type, :claim_details, :claimant_count, :date_of_receipt)
json.(claim, :desired_outcomes, :discrimination_claims, :is_unfair_dismissal, :jurisdiction, :miscellaneous_information)
json.(claim, :is_unfair_dismissal, :office_code, :other_claim_details, :other_known_claimant_names, :other_outcome)
json.(claim, :pay_claims, :send_claim_to_whistleblowing_entity, :submission_channel, :submission_reference)
if claim.employment_details.present?
  json.employment_details do
    json.partial! "et_exporter/v1/employment_details.json.jbuilder", employment: claim.employment_details
  end
else
  json.employment_details({})
end
json.primary_claimant do
  json.partial! "et_exporter/v1/claimant.json.jbuilder", claimant: claim.primary_claimant
end
json.secondary_claimants do
  json.partial! "et_exporter/v1/claimant.json.jbuilder", collection: claim.secondary_claimants, as: :claimant
end
json.primary_respondent do
  json.partial! "et_exporter/v1/respondent.json.jbuilder", respondent: claim.primary_respondent
end
json.secondary_respondents do
  json.partial! "et_exporter/v1/respondent.json.jbuilder", collection: claim.secondary_respondents, as: :respondent
end
json.uploaded_files do
  json.partial! "et_exporter/v1/uploaded_file.json.jbuilder", collection: claim.uploaded_files, as: :uploaded_file
end
