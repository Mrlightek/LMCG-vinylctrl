# ── app/models/gig.rb ────────────────────────────────────────────

class Gig < ApplicationRecord
  belongs_to :posted_by, class_name: "User"
  has_many   :gig_applications
  has_many   :applicants, through: :gig_applications, source: :user

  validates :title, :event_date, :venue_name, :budget, presence: true
  validates :genres, length: { minimum: 1 }

  scope :open,       -> { where(status: "open") }
  scope :upcoming,   -> { where("event_date >= ?", Date.today) }
  scope :by_genre,   ->(g) { where("? = ANY(genres)", g) if g.present? }
  scope :featured,   -> { where(featured: true) }
  scope :recent,     -> { order(created_at: :desc) }

  def applied_by?(user) = gig_applications.exists?(user: user)
  def deadline_passed?  = application_deadline.present? && application_deadline < Date.today
end
