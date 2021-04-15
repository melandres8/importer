# frozen_string_literal: true

class InvalidContact < ApplicationRecord
  include CreditCardValidation
  belongs_to :user
end
