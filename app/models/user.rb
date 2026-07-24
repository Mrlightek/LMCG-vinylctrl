# # ── app/models/user.rb ──────────────────────────────────────────

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  USER_TYPES = %w[dj artist venue organizer].freeze

  has_one  :profile, dependent: :destroy
  has_many :bookings_as_talent,  class_name: "Booking", foreign_key: :talent_id
  has_many :bookings_as_client,  class_name: "Booking", foreign_key: :client_id
  has_many :sent_messages,       class_name: "Message", foreign_key: :sender_id
  has_many :received_messages,   class_name: "Message", foreign_key: :recipient_id
  has_many :notifications
  has_many :gig_applications
  has_many :contracts,  foreign_key: :talent_id
  has_many :invoices,   foreign_key: :issuer_id
  has_many :profile_views,
         foreign_key: :viewer_id,
         inverse_of: :viewer,
         dependent: :nullify

  validates :user_type, inclusion: { in: USER_TYPES }
  validates :first_name, :last_name, presence: true

  after_create :create_default_profile

  scope :djs,        -> { where(user_type: "dj") }
  scope :artists,    -> { where(user_type: "artist") }
  scope :venues,     -> { where(user_type: "venue") }
  scope :organizers, -> { where(user_type: "organizer") }

  def full_name    = "#{first_name} #{last_name}"
  def initials     = "#{first_name[0]}#{last_name[0]}".upcase
  def dj?          = user_type == "dj"
  def artist?      = user_type == "artist"
  def venue?       = user_type == "venue"
  def organizer?   = user_type == "organizer"
  def talent?      = dj? || artist?
  def hirer?       = venue? || organizer?

  def all_bookings
    talent? ? bookings_as_talent : bookings_as_client
  end

  private

  def create_default_profile
    create_profile!(user: self, slug: generate_slug)
  end

  def generate_slug
    base = "#{first_name}-#{last_name}".downcase.gsub(/[^a-z0-9-]/, "-")
    Profile.exists?(slug: base) ? "#{base}-#{SecureRandom.hex(3)}" : base
  end
end
