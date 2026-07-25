class Notification < ApplicationRecord
  belongs_to :user

  validates :message, presence: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent_first, -> { order(created_at: :desc) }

  def read?
    read_at.present?
  end

  def mark_read!
    touch(:read_at)
  end
end
