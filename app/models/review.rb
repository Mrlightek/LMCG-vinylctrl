class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :body, length: { maximum: 2_000 }
end