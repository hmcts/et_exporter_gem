# frozen_string_literal: true

# A response is a response to an employment tribunal claim (ET3)
class Response < ApplicationRecord
  belongs_to :respondent
  belongs_to :representative, optional: true
  has_many :response_uploaded_files, dependent: :destroy
  has_many :uploaded_files, through: :response_uploaded_files
end
