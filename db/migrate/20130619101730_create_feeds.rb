class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :url
      t.string :feed_url
      t.string :etag
      t.datetime :last_modified

      t.timestamps
    end
  end
end
