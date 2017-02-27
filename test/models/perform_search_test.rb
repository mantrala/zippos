require 'test_helper'

class PerformSearchTest < ActiveSupport::TestCase
  test "user searches for an existing zip" do
    alice = users(:alice)
    flagstaff = zippos(:flagstaff)

    response = PerformSearch.run(flagstaff.zipcode, alice)
    assert response[:zippo]
    assert_equal flagstaff, response[:zippo]
  end

  test "user searches for a zip thats already user saved" do
    alice = users(:alice)
    tempe = zippos(:tempe)

    response = PerformSearch.run(tempe.zipcode, alice)
    assert response[:exists]
  end

  test "user searches for a zip that doesn't exist in db" do
    alice = users(:alice)
    return_hash = {:zipcode=>85281, :country=>"US", :country_abbr=>"US", :places=>"[]"}

    stub_request(:get, "http://api.zippopotam.us/us/85281").
      to_return(body: '{"country": "US", "post code": 85281, "country abbreviation": "US", "places": []}')

    response = PerformSearch.run("85281", alice)
    assert_nil response[:zippo]
    assert_nil response[:exists]
    assert_equal return_hash, response
  end
end
