class BookingsController < ApplicationController
  before_action :require_authentication

  def create
    @profile = Profile.published.available.find_by!(
      user_id: booking_params[:talent_id]
    )

    @booking = @profile.user.bookings_as_talent.build(booking_attributes)
    @booking.client = Current.user

    if @profile.user == Current.user
      redirect_to profile_path(@profile),
                  alert: "You cannot book your own profile."
    elsif @booking.save
      redirect_to profile_path(@profile),
                  notice: "Booking request sent."
    else
      prepare_profile_page
      render "profiles/show", status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(
      :talent_id,
      :venue_name,
      :venue_address,
      :event_date,
      :start_time,
      :end_time,
      :event_type,
      :genre,
      :client_notes
    )
  end

  def booking_attributes
    booking_params.except(:talent_id)
  end

  def prepare_profile_page
    @reviews = @profile.reviews.order(created_at: :desc).limit(10)
  end
end
