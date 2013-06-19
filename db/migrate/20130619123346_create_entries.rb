class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.string :url
      t.string :author
      t.text :summary
      t.text :content
      t.datetime :published
      t.references :feed, index: true

      t.timestamps
    end
  end
end
