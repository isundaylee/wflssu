class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.integer :admission_year
      t.integer :class_number
      t.integer :phone_number
      t.string :email
      t.integer :gender
      t.integer :qq
      t.date :birthday
      t.integer :department_id
      t.string :secondary_school
      t.integer :code_number
      t.text :memo
      t.string :password_digest
      t.string :remember_token

      t.timestamps
    end
  end
end
