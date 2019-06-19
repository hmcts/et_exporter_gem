# frozen_string_literal: true

# A respondent is the person who the claimant is claiming against
# A claim can have many respondents
class Respondent < ApplicationRecord
  belongs_to :address
  belongs_to :work_address, class_name: 'Address', required: false # rubocop:disable Rails/InverseOf
end
