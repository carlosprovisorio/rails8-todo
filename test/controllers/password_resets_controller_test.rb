# test/controllers/password_resets_controller_test.rb
require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "carlos@example.com",
      password: "supersecret",
      password_confirmation: "supersecret"
    )
    @token = @user.signed_id(purpose: :password_reset, expires_in: 30.minutes)
  end

  test "GET new should be success" do
    get new_password_reset_path
    assert_response :success
  end

  test "POST create should redirect to sign_in even if email exists" do
    post password_reset_path, params: { email: @user.email }
    assert_redirected_to sign_in_path
    follow_redirect!
    assert_match "reset link", @response.body
  end

  test "GET edit with valid token should be success" do
    get edit_password_reset_path(token: @token)
    assert_response :success
  end

  test "GET edit with invalid/expired token should redirect to new" do
    get edit_password_reset_path(token: "bad-token")
    assert_redirected_to new_password_reset_path
  end

  test "PUT update with valid token should redirect to sign_in" do
    put password_reset_path, params: {
      token: @token,
      user: { password: "newsupersecret", password_confirmation: "newsupersecret" }
    }
    assert_redirected_to sign_in_path
  end

  test "PUT update with invalid token should redirect to new" do
    put password_reset_path, params: {
      token: "bad-token",
      user: { password: "anything", password_confirmation: "anything" }
    }
    assert_redirected_to new_password_reset_path
  end
end
