require 'rails_helper'

RSpec.feature 'Sign in process' do
  before :each do
    User.create!(email: 'user@example.com', password: 'password')
  end

  scenario 'Signs me in' do
    visit new_user_session_path

    within '#new_user' do
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
    end

    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end
end
