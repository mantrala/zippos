require "test_helper"

feature "User registration" do
  scenario "users goes to the root url" do
    visit root_path

    page.must_have_content "Sign in"
    page.must_have_content "Remember me"
    page.current_path.must_equal '/users/sign_in'
  end

  scenario 'user creates a new profile' do
    visit new_user_registration_path

    within '#new_user' do
      fill_in 'Email',    with: 'new_user@jt.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_button 'Sign up'
    end

    page.must_have_content 'Welcome! You have signed up successfully.'
    page.current_path.must_equal '/'
  end

  scenario 'user enters valid input' do
    visit new_user_session_path

    within '#new_user' do
      fill_in 'Email',    with: 'alice@jt.com'
      fill_in 'Password', with: '123456'
      click_button 'Log in'
    end

    page.must_have_content 'Signed in successfully'
    page.must_have_content 'Recent Searches'
    page.current_path.must_equal '/'
  end
end
