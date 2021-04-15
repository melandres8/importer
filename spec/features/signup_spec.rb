require 'rails_helper'

RSpec.feature 'Sign up process' do
  scenario 'Signs me up' do
    visit new_user_registration_path

    within '#new_user' do
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
    end

    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
