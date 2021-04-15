# frozen_string_literal: true

# Imported file class
class ImportedFile < ApplicationRecord
  include AASM

  aasm column: 'state' do
    state :waiting, initial: true
    state :processing, :rejected, :finished

    event :waiting_to_match do
      transitions from: :waiting, to: :processing
    end

    event :processing_file do
      transitions from: %i[processing rejected], to: :finished
    end

    event :rejected_file do
      transitions from: :processing, to: :rejected
    end
  end
  belongs_to :user
  validates_presence_of :filename

  def import(params)
    CSV.foreach(params[:file].path, headers: true) do |row|
      contacts_hash = row.to_hash
      contact = user.contacts.build columns_matcher(params, contacts_hash)
      waiting_to_match! if may_waiting_to_match?
      if contact.save && may_processing_file?
        processing_file!
      else
        failed_contact!(params, contact, contacts_hash)
      end
    end
  end

  def failed_contact!(params, contact, contacts_hash)
    errors_msg = []
    errors_msg = contact.errors.full_messages.join(', ')
    invalid_contact = user.invalid_contacts.build columns_matcher(params, contacts_hash)
    invalid_contact.error_msg = errors_msg
    waiting_to_match! if may_waiting_to_match?
    invalid_contact.save
    rejected_file! if may_rejected_file?
  end

  def columns_matcher(params, row_hash)
    data = {}
    headers = %w[name birthdate phone address credit_card email]
    matcher = headers.each_with_object({}) do |key, hash|
      hash[params[key]] = key
    end
    row_hash.each do |key, value|
      next unless matcher.keys.include?(key)

      data[matcher[key]] = value
    end
    data
  end
end
