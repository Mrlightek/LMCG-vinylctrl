class ProfilesController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  before_action :set_public_profile, only: :show
  before_action :set_owned_profile, only: %i[edit update destroy]

  def index
    @profiles = Profile.published.available
    @profiles = @profiles.by_type(params[:type]) if params[:type].present?
    @profiles = @profiles.by_genre(params[:genre]) if params[:genre].present?
    @profiles = @profiles.by_city(params[:city]) if params[:city].present?
    @profiles = @profiles.by_rate_max(params[:max_rate]) if params[:max_rate].present?
    @profiles = @profiles.top_rated.page(params[:page]).per(20)
    @genres = Profile::GENRES
  end

  def show
    @reviews = @profile.reviews.order(created_at: :desc).limit(10)

    if authenticated? && @profile.user != Current.user
      @booking = Booking.new(talent: @profile.user)
    end

    @profile.increment!(:view_count)
  end

  def new
    @profile = Current.user.build_profile
  end

  def create
    @profile = Current.user.build_profile(profile_params)

    if @profile.save
      redirect_to profile_path(@profile),
                  notice: "Profile was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path(@profile),
                  notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @profile.destroy!

    redirect_to profiles_path,
                notice: "Profile deleted.",
                status: :see_other
  end

  private

  def set_public_profile
    scope = Profile.published

    if authenticated?
      scope = scope.or(Profile.where(user: Current.user))
    end

    @profile = scope.find_by!(slug: params.require(:slug))
  end

  def set_owned_profile
    @profile = Current.user.profile

    unless @profile&.slug == params[:slug]
      raise ActiveRecord::RecordNotFound
    end
  end

  def profile_params
    params.require(:profile).permit(
      :bio_name,
      :slug,
      :bio,
      :hourly_rate,
      :available,
      :published,
      :avatar,
      genres: [],
      photos: []
    )
  end
end