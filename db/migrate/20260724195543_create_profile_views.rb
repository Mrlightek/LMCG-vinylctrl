class CreateProfileViews < ActiveRecord::Migration[8.0]
  def change
    create_table :profile_views do |t|
      t.references :profile, null: false, foreign_key: true

      t.references :viewer,
                   null: true,
                   foreign_key: { to_table: :users }

      t.string :visitor_key, null: false
      t.date :viewed_on, null: false

      t.timestamps
    end

    add_index :profile_views,
              %i[profile_id visitor_key viewed_on],
              unique: true,
              name: "index_unique_daily_profile_views"

    add_index :profile_views,
              %i[profile_id viewed_on],
              name: "index_profile_views_by_profile_and_date"
  end
end