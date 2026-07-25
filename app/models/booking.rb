# ── app/models/booking.rb ────────────────────────────────────────

class Booking < ApplicationRecord
  STATUSES = %w[pending confirmed declined cancelled completed no_show].freeze

  belongs_to :talent, class_name: "User"
  belongs_to :client, class_name: "User"
  has_one    :contract, dependent: :destroy
  has_one    :invoice,  dependent: :destroy
  has_many   :messages, as: :context

  validates :status,       inclusion: { in: STATUSES }
  validates :event_date,   presence: true
  validates :start_time,   presence: true
  validates :venue_name,   presence: true
  validates :agreed_rate,  numericality: { greater_than: 0 }, allow_nil: true

  scope :upcoming,   -> { where("event_date >= ?", Date.today).order(:event_date) }
  scope :past,       -> { where("event_date < ?",  Date.today).order(event_date: :desc) }
  scope :pending,    -> { where(status: "pending") }
  scope :confirmed,  -> { where(status: "confirmed") }
  scope :for_user,   ->(u) { where(talent: u).or(where(client: u)) }
  scope :this_month, -> { where(event_date: Time.current.beginning_of_month..Time.current.end_of_month) }

  before_validation :set_defaults
  after_create_commit :send_notifications
  after_update      :handle_status_change, if: :saved_change_to_status?

  def duration_hours
    return nil unless start_time && end_time
    ((end_time - start_time) / 3600.0).round(1)
  end

  def confirm!   = update!(status: "confirmed")
  def decline!   = update!(status: "declined")
  def cancel!    = update!(status: "cancelled")
  def complete!  = update!(status: "completed")

  def status_color
    { "pending" => "warning", "confirmed" => "success",
      "declined" => "danger",  "cancelled" => "danger",
      "completed" => "muted" }.fetch(status, "muted")
  end

  def reference = "VC-#{id.to_s.rjust(6,"0")}"

  private

  def set_defaults
    self.status ||= "pending"
  end

  def send_notifications
    BookingMailer.request_received(self).deliver_later
    BookingMailer.new_booking_alert(self).deliver_later
    Notification.create!(user: talent, message: "New booking request from #{client.full_name}", link: "/dashboard/bookings/#{id}")
  end

  def handle_status_change
    BookingMailer.status_update(self).deliver_later
  end
end