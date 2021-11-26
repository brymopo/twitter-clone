class AddCountsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :followers_count, :integer, default: 0, null: false
    add_column :users, :following_count, :integer, default: 0, null: false
  end
end
