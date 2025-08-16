require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # uses fixtures/users.yml
  end

  test "GET /sign_in renders" do
    get sign_in_path
    assert_response :success
  end

  test "POST /sign_in authenticates" do
    post sign_in_path, params: { email: @user.email, password: "password123" }
    assert_redirected_to root_path
  end

  test "DELETE /sign_out logs out" do
    # sign in first
    post sign_in_path, params: { email: @user.email, password: "password123" }
    delete sign_out_path
    assert_redirected_to sign_in_path
  end
end
