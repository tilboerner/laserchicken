class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true
      t.references :feed, index: true

      t.timestamps
    end
    add_index :subscriptions, [:user_id, :feed_id], unique: true
  end
end
