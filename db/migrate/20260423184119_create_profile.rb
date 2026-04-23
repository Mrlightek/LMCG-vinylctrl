class CreateProfile < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.belongs_to :user,      null: false, foreign_key: true
      t.string     :slug,      null: false
      t.string     :bio_name
      t.text       :bio
      t.string     :tagline
      t.integer    :hourly_rate
      t.json     :genres, default: []
      t.string     :equipment
      t.string     :website
      t.string     :instagram
      t.string     :soundcloud
      t.string     :youtube
      t.boolean    :published,  default: false
      t.boolean    :available,  default: true
      t.boolean    :featured,   default: false
      t.float      :average_rating, default: 0.0
      t.integer    :total_bookings,  default: 0
      t.json      :settings,   default: {}

      t.timestamps
    end

    add_index :profiles, :slug,           unique: true
    add_index :profiles, :published
    add_index :profiles, :available
    add_index :profiles, :genres,         using: :gin
    add_index :profiles, :average_rating
  end
end

# # ── db/migrate/XXXXXX_create_profiles.rb ─────────────────────────

# class CreateProfiles < ActiveRecord::Migration[7.1]
#   
# end
