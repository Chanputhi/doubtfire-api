require 'test_helper'

class UnitRolesTest < ActiveSupport::TestCase
  include Rack::Test::Methods
  include TestHelpers::AuthHelper
  include TestHelpers::JsonHelper

  def app
    Rails.application
  end

  # GET /api/units_roles
  def test_get_unit_roles
    get '/api/unit_roles'
    # UnitRole.joins(:role, :unit).where("user_id = :user_id and roles.name <> 'Student'", user_id: user.id)

    # asserts
  end

  # Get a unit role's details
  def test_get_a_unit_roles_details
    expected_ur = UnitRole.second

    # perform the GET 
    get with_auth_token"/api/unit_roles/#{expected_ur.id}"
    returned_ur = last_response_body

    # Check if the call succeeds
    assert_equal 200, last_response.status
    
    # Check the returned details match as expected
    response_keys = %w(unit_id user_id)
    assert_json_matches_model(returned_ur, expected_ur, response_keys)
  end
  
  def test_post_bad_unit_roles
    num_of_unit_roles = UnitRole.all.count

    to_post = {
      unit_id: 1,
      user_id: 1,
      role: 'asdf'
    }

    post '/api/unit_roles', with_auth_token(to_post)
    assert_equal last_response.status, 403
    assert_equal num_of_unit_roles, UnitRole.all.count
  end

  def test_post_unit_roles_not_unique
    num_of_unit_roles = UnitRole.all.count
    to_post = {
      unit_id: 1,
      user_id: 1,
      role: 'tutor'
    }
    post '/api/unit_roles', with_auth_token(to_post)

    assert_equal last_response.status, 201
    assert_equal num_of_unit_roles, UnitRole.all.count

    assert_equal to_post[:unit_id], last_response_body['unit_id']
    assert_equal to_post[:user_id], last_response_body['user_id']
  end
end
