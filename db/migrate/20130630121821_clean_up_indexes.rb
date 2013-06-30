class CleanUpIndexes < ActiveRecord::Migration
  def up
    remove_index :subscriptions, :user_id
    add_index :user_states, [:entry_id, :user_id], unique: true
    remove_index :user_states, :entry_id
  end

  def down
    add_index :subscriptions, :user_id
    remove_index :user_states, [:entry_id, :user_id]
    add_index :user_states, :entry_id
  end
end
