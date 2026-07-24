class ProfileView < ApplicationRecord
  belongs_to :profile, counter_cache: :view_count
  belongs_to :viewer, class_name: "User", optional: true

  validates :visitor_key, presence: true
  validates :viewed_on, presence: true

  validates :visitor_key,
            uniqueness: { scope: %i[profile_id viewed_on] }
end