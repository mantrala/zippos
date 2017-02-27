require_relative '../test_helper'

class ZippopotamusTest < ActiveSupport::TestCase
  test "will make a HTTP get to hippopotamus" do
    stub_request(:get, "http://api.zippopotam.us/us/85281").
      to_return(body: '{"country": "US"}')

  	zippopotamus = Zippopotamus.new 85281
    response = zippopotamus.run
  	assert_not_nil response
    assert_equal response[:country], "US"
  end

  test "HTTP get will raise a exception when response is not a JSON" do
    stub_request(:get, "http://api.zippopotam.us/us/85281").
      to_return(body: '')

    zippopotamus = Zippopotamus.new 85281
    response = zippopotamus.run
    assert_not_nil response[:error]
  end

  test "will throw an error if zip is blank" do
    assert_raise ArgumentError do
      zippopotamus = Zippopotamus.new
      zippopotamus.run
    end
  end

  test "will return empty hash if a zip is not found" do
    stub_request(:get, "http://api.zippopotam.us/us/8528145345345").
      to_return(body: '{}', status: 404)

    zippopotamus = Zippopotamus.new 8528145345345
    response = zippopotamus.run
    assert response.empty?
  end

  test "will return return if an api error occurs" do
    stub_request(:get, "http://api.zippopotam.us/us/8528145345345").
      to_return(body: '{}', status: 500)

    zippopotamus = Zippopotamus.new 8528145345345
    response = zippopotamus.run
    assert response[:error]
  end
end
