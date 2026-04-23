# # ── app/models/invoice.rb ────────────────────────────────────────

class Invoice < ApplicationRecord
  belongs_to :booking
  belongs_to :issuer, class_name: "User"
  belongs_to :recipient, class_name: "User"

  STATUSES = %w[draft sent paid overdue cancelled].freeze
  validates :status, inclusion: { in: STATUSES }

  scope :paid,    -> { where(status: "paid") }
  scope :unpaid,  -> { where.not(status: "paid") }
  scope :overdue, -> { where(status: "overdue") }

  def number = "INV-#{id.to_s.rjust(5,"0")}"
  def paid?  = status == "paid"

  def mark_paid!(method: nil)
    update!(status: "paid", paid_at: Time.current, payment_method: method)
    booking.update!(invoice_paid: true)
  end
end