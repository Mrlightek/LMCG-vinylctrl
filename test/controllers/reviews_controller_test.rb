require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as @user

    @profile = Profile.create!(
      user: users(:two),
      slug: "review-test-profile"
    )
  end

  test "should create review for profile" do
    assert_difference("Review.count", 1) do
      post profile_reviews_url(@profile), params: {
        review: {
          rating: 5,
          body: "Excellent experience."
        }
      }
    end

    review = Review.order(:created_at).last

    assert_equal @profile, review.reviewable
    assert_equal @user, review.user
    assert_equal 5, review.rating
    assert_redirected_to profile_url(@profile)
  end

  test "should require authentication" do
    delete session_url

    assert_no_difference("Review.count") do
      post profile_reviews_url(@profile), params: {
        review: {
          rating: 5,
          body: "Excellent experience."
        }
      }
    end

    assert_redirected_to new_session_url
  end
end
