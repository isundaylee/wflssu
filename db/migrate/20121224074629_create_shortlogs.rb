class CreateShortlogs < ActiveRecord::Migration
  def change
    create_table :shortlogs do |t|
      t.text :content
      t.integer :member_id

      t.timestamps
    end
  end
end
