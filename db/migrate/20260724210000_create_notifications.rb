class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :message, null: false
      t.string :link
      t.datetime :read_at

      t.timestamps
    end

    add_index :notifications, %i[user_id read_at]
  end
end
