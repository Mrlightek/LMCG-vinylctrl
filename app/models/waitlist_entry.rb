# # ── app/models/waitlist_entry.rb ─────────────────────────────────

class WaitlistEntry < ApplicationRecord
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :user_type, inclusion: { in: User::USER_TYPES + ["any"] }, allow_blank: true

  after_create :send_confirmation

  private

  def send_confirmation
    WaitlistMailer.confirmation(self).deliver_later
  end
end