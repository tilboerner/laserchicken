class AddUniqueIndexToFeedUrls < ActiveRecord::Migration
  def change
    add_index :feeds, :feed_url, unique: true
  end
end
