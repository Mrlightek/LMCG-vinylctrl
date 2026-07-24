# ── app/models/profile.rb ───────────────────────────────────────

class Profile < ApplicationRecord
  belongs_to :user
  has_many_attached :photos
  has_one_attached  :avatar

  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :availabilities
  has_many :profile_views, dependent: :destroy

  validates :slug, uniqueness: true, presence: true

  scope :published,   -> { where(published: true) }
  scope :by_type,     ->(t)  { joins(:user).where(users: { user_type: t }) if t.present? }
  scope :by_genre,    ->(g)  { where("? = ANY(genres)", g) if g.present? }
  scope :by_city,     ->(c)  { joins(:user).where("users.city ILIKE ?", "%#{c}%") if c.present? }
  scope :by_rate_max, ->(r)  { where("hourly_rate <= ?", r.to_i) if r.present? }
  scope :available,   -> { where(available: true) }
  scope :top_rated,   -> { order(average_rating: :desc) }
  scope :featured,    -> { where(featured: true) }

  GENRES = %w[
    hip-hop house afrobeats r&b soul reggaeton
    trap edm top-40 latin dancehall techno pop jazz
  ].freeze

  def display_name  = bio_name.presence || user.full_name
  def location      = [user.city, user.state].compact.join(", ")
  def rate_display  = hourly_rate ? "$#{hourly_rate}/hr" : "Contact for rates"
  def to_param      = slug

  def average_rating
    return 0 if reviews.empty?
    reviews.average(:rating).to_f.round(1)
  end

  def review_count = reviews.count
end