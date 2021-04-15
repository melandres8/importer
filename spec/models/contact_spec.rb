# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:user) { User.create!(email: 'user@example.com', password: 'password') }
  subject(:contact) {
    described_class.new(
      name: 'Someone', birthdate: '1999-11-08', phone: '(+57) 317-730-71-72', address: 'Some address',
      credit_card: '5274576394259961', four_digits: '9961', franchise: 'MasterCard', email: 'user@example.com', user_id: user.id
    )
  }

  describe 'validating attributes' do
    it { is_expected.to be_valid }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:birthdate) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:credit_card) }
    it { should validate_presence_of(:franchise) }
    it { should validate_presence_of(:email) }
  end

  describe 'name validation' do
    it {
      should_not allow_value('Some!One1').for(:name)
                                         .with_message('can only have (-) as a special character')
    }

    it { should allow_value('Someone').for(:name) }
    it { should allow_value('Some One').for(:name) }
    it { should allow_value('Some One1').for(:name) }
    it { should allow_value('Some-One1').for(:name) }
  end

  describe 'birthdate contact validation' do
    it { should allow_value('19991108').for(:birthdate) }
    it { should allow_value('1999-11-08').for(:birthdate) }
  end

  describe 'format email validations' do
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('user@example').for(:email) }
    it {
      should validate_uniqueness_of(:email)
        .case_insensitive.scoped_to(:user_id)
        .with_message("contacts can't have the same email")
    }
  end

  describe 'format phone validations' do
    it { should allow_value('(+57) 317 730 71 72').for(:phone) }
    it { should allow_value('(+57) 317-730-71-72').for(:phone) }
    it {
      should_not allow_value('317 730 71 72').for(:phone)
                                             .with_message('Allowed formats (+57) 320 432 05 09, (+57) 320-432-05-09')
    }
  end

  describe 'generating 4 last digits' do
    it 'should accept Master card and show 4 last digits' do
      expect(contact.four_digits).to eq('9961')
    end
  end

  describe 'franchise validations' do
    it 'should accept Mastercard Card' do
      contact.credit_card = '5555555555554444'
      expect(contact.franchise).to eq('MasterCard')
    end

    it 'should reject wrong number Card' do
      contact.credit_card = '11111111111'
      expect(contact.valid?).to be_falsy
    end
  end

  describe 'Assosiations' do
    it { should belong_to(:user) }
  end

  describe 'Validations' do
    it { 
      should validate_uniqueness_of(:email)
        .case_insensitive.scoped_to(:user_id)
        .with_message("contacts can't have the same email")
    }
  end
end

