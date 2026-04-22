require "application_system_test_case"

class LandingPagesTest < ApplicationSystemTestCase
  setup do
    @landing_page = landing_pages(:one)
  end

  test "visiting the index" do
    visit landing_pages_url
    assert_selector "h1", text: "Landing pages"
  end

  test "should create landing page" do
    visit landing_pages_url
    click_on "New landing page"

    click_on "Create Landing page"

    assert_text "Landing page was successfully created"
    click_on "Back"
  end

  test "should update Landing page" do
    visit landing_page_url(@landing_page)
    click_on "Edit this landing page", match: :first

    click_on "Update Landing page"

    assert_text "Landing page was successfully updated"
    click_on "Back"
  end

  test "should destroy Landing page" do
    visit landing_page_url(@landing_page)
    click_on "Destroy this landing page", match: :first

    assert_text "Landing page was successfully destroyed"
  end
end
