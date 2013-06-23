class CreateUserStates < ActiveRecord::Migration
  def change
    create_table :user_states do |t|
      t.references :entry, index: true
      t.references :user, index: true
      t.boolean :seen
      t.boolean :starred

      t.timestamps
    end
  end
end
