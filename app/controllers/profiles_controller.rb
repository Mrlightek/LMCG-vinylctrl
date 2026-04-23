# # ── app/controllers/profiles_controller.rb ──────────────────────

class ProfilesController < ApplicationController
  def index
    @profiles = Profile.published.available
    @profiles = @profiles.by_type(params[:type])     if params[:type]
    @profiles = @profiles.by_genre(params[:genre])   if params[:genre]
    @profiles = @profiles.by_city(params[:city])     if params[:city]
    @profiles = @profiles.by_rate_max(params[:max_rate]) if params[:max_rate]
    @profiles = @profiles.top_rated.page(params[:page]).per(20)
    @genres   = Profile::GENRES
  end

  def show
    @profile  = Profile.published.find_by!(slug: params[:slug])
    @reviews  = @profile.reviews.order(created_at: :desc).limit(10)
    @booking  = Booking.new if user_signed_in?
    @profile.increment!(:view_count)
  end
end


