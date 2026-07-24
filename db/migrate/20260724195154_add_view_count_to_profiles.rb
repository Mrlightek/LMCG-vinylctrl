class AddViewCountToProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :view_count, :integer, default: 0, null: false
    add_index :profiles, :view_count
  end
end
