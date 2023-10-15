class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :subject, polymorphic: true
      t.integer :user_id
      t.integer :action_type, null: false
      t.boolean :checked

      t.timestamps
    end
  end
end
