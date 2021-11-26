class CreateTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :tweets do |t|
      t.string :message, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :tweets, :created_at
  end
end
