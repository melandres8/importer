# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(password: 'password', email: 'user@example.com') }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe 'Associations' do
    it { should have_many(:contacts) }
    it { should have_many(:imported_files) }
    it { should have_many(:invalid_contacts) }
  end
end
