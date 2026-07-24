class ReviewsController < ApplicationController
  before_action :require_authentication
  before_action :set_profile

  def create
    @review = @profile.reviews.build(review_params)
    @review.user = Current.user

    if @review.save
      redirect_to profile_path(@profile),
                  notice: "Your review was added."
    else
      redirect_to profile_path(@profile),
                  alert: @review.errors.full_messages.to_sentence
    end
  end

  private

  def set_profile
    @profile = Profile.find_by!(slug: params[:profile_slug])
  end

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end