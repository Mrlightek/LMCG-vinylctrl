# # ── db/migrate/XXXXXX_create_gigs.rb ─────────────────────────────

class CreateGig < ActiveRecord::Migration[8.0]
  def change
    create_table :gigs do |t|
      t.belongs_to :posted_by,  null: false, foreign_key: { to_table: :users }
      t.string     :title,      null: false
      t.text       :description
      t.string     :venue_name
      t.string     :venue_city
      t.string     :venue_state
      t.date       :event_date
      t.time       :start_time
      t.time       :end_time
      t.json     :genres,  default: []
      t.decimal    :budget,     precision: 10, scale: 2
      t.string     :status,     default: "open"
      t.date       :application_deadline
      t.boolean    :featured,   default: false
      t.integer    :views_count, default: 0

      t.timestamps
    end

    add_index :gigs, :status
    add_index :gigs, :event_date
    add_index :gigs, :genres, using: :gin
  end
end