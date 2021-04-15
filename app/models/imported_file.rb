# frozen_string_literal: true

# Imported file class
class ImportedFile < ApplicationRecord
  include AASM

  aasm column: 'state' do
    state :waiting, initial: true
    state :processing, :rejected, :finished

    event :processing_file do
      transitions from: %i[processing rejected], to: :finished
    end

    event :rejected_file do
      transitions from: :processing, to: :rejected
    end
  end
  belongs_to :user
  validates_presence_of :filename

  def import(file, user)
    CSV.foreach(file, headers: true) do |row|
      contacts_hash = row.to_hash
      contact = Contact.new(name: contacts_hash['name'], birthdate: contacts_hash['birthdate'],
                            phone: contacts_hash['phone'], address: contacts_hash['address'],
                            credit_card: contacts_hash['credit_card'], franchise: contacts_hash['credit_card'],
                            four_digits: contacts_hash['credit_card'], email: contacts_hash['email'],
                            user_id: user.id)
      unless contact.save
        errors_msg = []
        errors_msg = contact.errors.full_messages.join(', ')
        invalid_contact = InvalidContact.new(name: contacts_hash['name'], birthdate: contacts_hash['birthdate'],
                                             phone: contacts_hash['phone'], address: contacts_hash['address'],
                                             credit_card: contacts_hash['credit_card'], franchise: contacts_hash['credit_card'],
                                             four_digits: contacts_hash['credit_card'], email: contacts_hash['email'],
                                             user_id: user.id, error_msg: errors_msg)
        rejected_file! if invalid_contact.save! && may_rejected_file?
      end
    end
  end
end
