json.extract! review, :id, :reviewable_id, :reviewable_type, :user_id, :rating, :body, :created_at, :updated_at
json.url review_url(review, format: :json)
