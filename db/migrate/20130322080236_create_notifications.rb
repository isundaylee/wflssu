class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :content
      t.string :link
      t.integer :member_id

      t.timestamps
    end
  end
end
