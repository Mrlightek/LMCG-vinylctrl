class AddFirstNameToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name,   :string, null: false, default: ""
    add_column :users, :last_name,    :string, null: false, default: ""
    add_column :users, :user_type,    :string, null: false, default: "dj"
    add_column :users, :phone,        :string
    add_column :users, :city,         :string
    add_column :users, :state,        :string
    add_column :users, :plan,         :string, default: "free"
    add_index  :users, :user_type
  end
end
