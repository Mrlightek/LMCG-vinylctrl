# # ── app/models/contract.rb ───────────────────────────────────────

class Contract < ApplicationRecord
  belongs_to :booking
  belongs_to :talent, class_name: "User"
  belongs_to :client, class_name: "User"

  scope :unsigned, -> { where(signed_at: nil) }
  scope :signed,   -> { where.not(signed_at: nil) }

  def signed?   = signed_at.present?
  def pending?  = !signed?

  def sign!(user)
    update!(signed_at: Time.current, signed_by: user.id)
    booking.update!(contract_signed: true)
    ContractMailer.signed(self).deliver_later
  end
end
