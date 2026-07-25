require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client = users(:one)
    @talent = users(:two)

    @profile = @talent.profile || Profile.create!(
      user: @talent,
      slug: "booking-test-talent"
    )

    @profile.update!(
      published: true,
      available: true
    )

    sign_in_as @client
  end

  test "should create booking for available published talent" do
    assert_difference("Booking.count", 1) do
      post bookings_url, params: {
        booking: valid_booking_attributes
      }
    end

    booking = Booking.order(:created_at).last

    assert_equal @talent, booking.talent
    assert_equal @client, booking.client
    assert_equal "pending", booking.status
    assert_equal "VinylCTRL Test Venue", booking.venue_name
    assert_redirected_to profile_url(@profile)
  end

  test "should render profile with validation errors" do
    assert_no_difference("Booking.count") do
      post bookings_url, params: {
        booking: valid_booking_attributes.merge(
          venue_name: "",
          start_time: ""
        )
      }
    end

    assert_response :unprocessable_entity
    assert_select ".profile-errors"
  end

  test "should require authentication" do
    delete session_url

    assert_no_difference("Booking.count") do
      post bookings_url, params: {
        booking: valid_booking_attributes
      }
    end

    assert_redirected_to new_session_url
  end

  test "should not allow booking an unavailable profile" do
    @profile.update!(available: false)

    assert_no_difference("Booking.count") do
      post bookings_url, params: {
        booking: valid_booking_attributes
      }
    end

    assert_response :not_found
  end

  private

  def valid_booking_attributes
    {
      talent_id: @talent.id,
      venue_name: "VinylCTRL Test Venue",
      venue_address: "100 Music Avenue",
      event_date: 30.days.from_now.to_date,
      start_time: "20:00",
      end_time: "22:00",
      event_type: "Live performance",
      genre: "House",
      client_notes: "Testing the complete booking request."
    }
  end
end
