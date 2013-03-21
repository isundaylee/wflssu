class CreateAttendences < ActiveRecord::Migration
  def change
    create_table :attendences do |t|
      t.integer :event_id
      t.integer :member_id
      t.integer :state

      t.timestamps
    end
  end
end
