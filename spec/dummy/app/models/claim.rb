# frozen_string_literal: true

# A claim is an employee tribunal claim (form the ET1 form)
class Claim < ApplicationRecord
  has_many :claim_claimants, dependent: :destroy
  has_many :claim_respondents, dependent: :destroy
  has_many :claim_representatives, dependent: :destroy
  has_many :claim_uploaded_files, dependent: :destroy

  belongs_to :primary_claimant, class_name: 'Claimant', inverse_of: false

  has_many :secondary_claimants, dependent: :destroy, class_name: 'Claimant',
                                 through: :claim_claimants, source: :claimant
  belongs_to :primary_respondent, class_name: 'Respondent', inverse_of: false, optional: true
  has_many :secondary_respondents, dependent: :destroy, class_name: 'Respondent',
                                   through: :claim_respondents, source: :respondent
  belongs_to :primary_representative, class_name: 'Representative', inverse_of: false, optional: true
  has_many :secondary_representatives, class_name: 'Representative',
                                       through: :claim_representatives, source: :representative
  has_many :uploaded_files, through: :claim_uploaded_files
  has_many :pre_allocated_file_keys, as: :allocated_to, dependent: :destroy, inverse_of: :allocated_to
end
