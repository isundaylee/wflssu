class AddPrivilegeToMembers < ActiveRecord::Migration
  def change
    add_column :members, :privilege, :integer
  end
end
