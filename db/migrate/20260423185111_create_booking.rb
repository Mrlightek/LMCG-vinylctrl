

# # ── db/migrate/XXXXXX_create_bookings.rb ─────────────────────────

class CreateBooking < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.belongs_to :talent,      null: false, foreign_key: { to_table: :users }
      t.belongs_to :client,      null: false, foreign_key: { to_table: :users }
      t.string     :status,      null: false, default: "pending"
      t.string     :venue_name,  null: false
      t.string     :venue_address
      t.date       :event_date,  null: false
      t.time       :start_time
      t.time       :end_time
      t.string     :event_type                # birthday, club night, corporate, festival
      t.string     :genre
      t.decimal    :agreed_rate, precision: 10, scale: 2
      t.text       :notes
      t.text       :client_notes
      t.string     :reference
      t.boolean    :contract_signed, default: false
      t.boolean    :invoice_paid,    default: false

      t.timestamps
    end

    add_index :bookings, :status
    add_index :bookings, :event_date
    add_index :bookings, [:talent_id, :event_date]
    add_index :bookings, [:client_id, :event_date]
  end
end
