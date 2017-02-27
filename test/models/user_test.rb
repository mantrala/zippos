require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "required fields for User" do
    u = User.new

    assert u.invalid?
    assert_equal 2, u.errors.count
    assert_not_nil u.errors.messages[:email]
    assert_not_nil u.errors.messages[:password]
  end
end
