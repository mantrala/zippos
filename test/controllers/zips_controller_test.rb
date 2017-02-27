# require 'test_helper'
require_relative '../test_helper'

class ZipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include Rails::Controller::Testing::TestProcess

  test "user needs to be signed_in before the root page" do
    get zips_url
    assert_redirected_to new_user_session_url
  end

  test "index page" do
    sign_in users(:alice)

    get zips_url
    assert assigns(:searches)
    assert_response :success
  end

  test "index page returns current users zip codes" do
    sign_in users(:joe)

    get zips_url
    searches = assigns(:searches)
    assert_equal 2, searches.count, "The user owns only two request"
  end

  test "search a zipcode and save it" do
    sign_in users(:alice)

    assert_difference('Zippo.count') do
      stub_request(:get, "http://api.zippopotam.us/us/85281").
      to_return(body: '{"country": "US", "post code": 85281, "country abbreviation": "US", "places": []}')

      post search_url, params: {search: 85281}
    end
    
    assert_not_nil flash[:success]
    assert_redirected_to root_path
  end

  test "search for invalid zip code" do
    sign_in users(:alice)

    assert_no_difference('Zippo.count') do
      stub_request(:get, "http://api.zippopotam.us/us/8528145345345").
      to_return(body: '{}', status: 404)

      post search_url, params: {search: 8528145345345}
    end
    
    assert_not_nil flash[:notice]
    assert_redirected_to root_path
  end

  test "search will raise a error when response is not a JSON" do
    sign_in users(:alice)

    assert_no_difference('Zippo.count') do
      stub_request(:get, "http://api.zippopotam.us/us/85281").
      to_return(body: '')

      post search_url, params: {search: 85281}
    end
    
    assert_not_nil flash[:error]
    assert_redirected_to root_path
  end

  test "an existing zip should not be saved twice in Zippo" do
    alice = users(:alice)
    flagstaff = zippos(:flagstaff)
    sign_in alice

    previous_alice_count = Zippo.recent_user_searches(alice.id).count

    assert_no_difference("Zippo.count", "Existing zip should only be saved once") do
      stub_request(:get, "http://api.zippopotam.us/us/#{flagstaff.zipcode}").
      to_return(body: '{"country": "US", "post code": 86001, "country abbreviation": "US", "places": []}')

      post search_url, params: {search: flagstaff.zipcode}
    end

    assert_equal Zippo.recent_user_searches(alice.id).count, previous_alice_count + 1
  end

  test "an existing zip for a user should not be saved twice" do
    alice = users(:alice)
    tempe = zippos(:tempe)
    sign_in alice

    previous_alice_count = Zippo.recent_user_searches(alice.id).count

    stub_request(:get, "http://api.zippopotam.us/us/#{tempe.zipcode}").
    to_return(body: '{"country": "US", "post code": 85284, "country abbreviation": "US", "places": []}')

    post search_url, params: {search: tempe.zipcode}

    assert_equal Zippo.recent_user_searches(alice.id).count, previous_alice_count
  end

end
