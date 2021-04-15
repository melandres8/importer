# frozen_string_literal: true

# Credit card validation
module CreditCardValidation
  extend ActiveSupport::Concern
  included do
    validate :credit_card_validations, :encrypted
  end

  def credit_card_validations
    card = CreditCard.new(credit_card)
    self.franchise = card.franchise
    if card
      self.four_digits = card.last_digits
    else
      errors.add(:credit_card, 'Invalid data')
    end
  end

  def encrypted
    self.credit_card = CreditCard.new(credit_card).credit_card_encryptation
  end
end
