class AddCounterCacheForFeedSubscriptions < ActiveRecord::Migration
  def up
    add_column :feeds, :subscriptions_count, :integer, default: 0
    add_column :feeds, :entries_count, :integer, default: 0

    Feed.reset_column_information
    Feed.all.each do |feed|
      Feed.reset_counters feed.id, :subscriptions
      Feed.reset_counters feed.id, :entries
    end
  end

  def down
    remove_column :feeds, :subscriptions_count
    remove_column :feeds, :entries_count
  end
end
