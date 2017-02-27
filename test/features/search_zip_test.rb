require "test_helper"

feature "SearchZip" do
  scenario 'enters a correct zip and its saved' do

    stub_request(:get, "http://api.zippopotam.us/US/21252").
    to_return(:status => 200, body: '{"country": "US", "post code": 85281, "country abbreviation": "US", "places": []}')

    visit new_user_session_path

    fill_in 'Email',    with: 'alice@jt.com'
    fill_in 'Password', with: '123456'
    click_button 'Log in'

    visit root_path
    fill_in 'search', with: '21252'
    page.find('.glyphicon-search').click

    page.must_have_content 'Location details have been saved'
    page.current_path.must_equal '/'
  end
end
