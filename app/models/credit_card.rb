# frozen_string_literal: true

# CreditCard service class
class CreditCard
  def initialize(credit_card)
    @credit_card = credit_card
  end

  def franchise
    CreditCardValidations::Detector.new(@credit_card).brand_name
  end

  def last_digits
    @credit_card.last(4).to_s
  end

  def credit_card_encryptation
    BCrypt::Password.create(@credit_card)
  end
end
