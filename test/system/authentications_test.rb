require "application_system_test_case"

class AuthenticationsTest < ApplicationSystemTestCase
  test "user can sign up and sign in" do
    visit sign_up_path

    within 'form[action="/sign_up"]' do
      fill_in "First name",	with: "Carlos"
      fill_in "Email",	with: "carlos@example.com"
      fill_in "Password", with: "supersecret"
      fill_in "Password confirmation", with: "supersecret"
      click_on "Sign up"
    end

    assert_text "Welcome"

    click_on "Sign out"
    assert_text "Signed out."

    visit sign_in_path
    within 'form[action="/sign_in"]' do
      fill_in "Email",	with: "carlos@example.com"
      fill_in "Password", with: "supersecret"
      click_on "Sign in"
    end
    assert_text "Signed in."
  end
end
