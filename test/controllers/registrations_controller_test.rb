require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "GET /sign_up renders" do
    get sign_up_path
    assert_response :success
  end

  test "POST /sign_up creates a user and signs in" do
    assert_difference("User.count", +1) do
      post sign_up_path, params: {
        user: {
          first_name: "Test",
          email: "signup_test@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_match "Welcome", @response.body
  end
end
