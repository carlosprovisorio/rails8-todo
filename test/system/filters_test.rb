require "application_system_test_case"

class FiltersTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(email: "user@example.com", password: "password123")
    @list = @user.lists.create!(name: "Work", color: "#2b6cb0")
    @user.tasks.create!(list: @list, title: "Write spec", priority: :high, status: :todo, due_at: Time.current)
    @user.tasks.create!(list: @list, title: "Refactor", priority: :low,  status: :todo, due_at: nil)
  end

  test "search and filter tasks" do
    login
    visit list_path(@list)

    fill_in "Search", with: "Write"
    assert_text "Write spec"
    refute_text "Refactor"

    select "Today", from: "Due"
    assert_text "Write spec"

    select "Priority", from: "Sort"
    assert_text "Write spec" # still present
  end

  def login
    visit sign_in_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password123"

    # Scope to the sign-in form so we don't hit the navbar link
    within("form[action='#{sign_in_path}']") do
    click_button "Sign in"
  end

  assert_text "Signed in."
  end
end
