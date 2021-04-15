# frozen_string_literal: true

# Contact class model
class Contact < ApplicationRecord
  include CreditCardValidation

  belongs_to :user
  NAME_FORMAT = /\A[a-zA-Z\s\d\-]+\z/
  EMAIL_PATTERN = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  PHONE_PATTERN = /(\(\+\d{2}\)\s\d{3}\-\d{3}\-\d{2}\-\d{2}\z|\(\+\d{2}\)\s\d{3}\s\d{3}\s\d{2}\s\d{2}\z)/

  validates_presence_of :name, :birthdate,
                        :phone, :address, :credit_card,
                        :franchise, :email

  validates :phone, format: { with: PHONE_PATTERN,
                              message: 'Allowed formats (+57) 320 432 05 09, (+57) 320-432-05-09' }
  validates :email, format: { with: EMAIL_PATTERN }, uniqueness: { case_sensitive: false,
                                                                   scope: :user_id,
                                                                   message: "contacts can't have the same email" }
  validates :name, format: { with: NAME_FORMAT, message: 'can only have (-) as a special character' }
  validate :birthdate_format

  def birthdate_format
    Date.iso8601(birthdate)
  rescue StandardError
    errors.add(:birthdate, 'invalid format')
  end
end
