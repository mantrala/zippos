require 'test_helper'

class ZippoTest < ActiveSupport::TestCase
  test "creating an object from json" do
    obj = {
      "post code"=>"98324",
      "country"=>"United States",
      "country abbreviation"=>"US", 
      "places"=>[{
        "place name"=>"Carlsborg",
        "longitude"=>"-123.873",
        "state"=>"Washington",
        "state abbreviation"=>"WA","latitude"=>"48.1832"
      }]
    }

    returned_hash = Zippo.build_with_json(obj)

    assert_equal obj['post code'],            returned_hash[:zipcode]
    assert_equal obj['country'],              returned_hash[:country]
    assert_equal obj['country abbreviation'], returned_hash[:country_abbr]
  end

  test "required fields for Zippo" do
    z = Zippo.new country_abbr: 'US'

    assert z.invalid?
    assert_equal 2, z.errors.count
    assert_not_nil z.errors.messages[:zipcode]
    assert_not_nil z.errors.messages[:country]
  end
end
