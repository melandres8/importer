# frozen_string_literal: true

# Imported file class
class ImportedFile < ApplicationRecord
  include AASM

  aasm column: 'state' do
    state :processing, initial: true
    state :waiting, :rejected, :finished

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
      if contact.save && may_processing_file?
        processing_file!
      else
        failed_contact!(file, user, contact, contacts_hash)
      end
    end
  end

  def failed_contact!(file, user, contact, contacts_hash)
    errors_msg = []
    errors_msg = contact.errors.full_messages.join(', ')
    invalid_contact = InvalidContact.new(name: contacts_hash['name'], birthdate: contacts_hash['birthdate'],
                                         phone: contacts_hash['phone'], address: contacts_hash['address'],
                                         credit_card: contacts_hash['credit_card'], franchise: contacts_hash['credit_card'],
                                         four_digits: contacts_hash['credit_card'], email: contacts_hash['email'],
                                         user_id: user.id, error_msg: errors_msg)
    invalid_contact.save
    rejected_file! if may_rejected_file?
  end
end
