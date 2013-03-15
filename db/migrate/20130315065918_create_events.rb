class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :memo
      t.date :on_date

      t.timestamps
    end
  end
end
