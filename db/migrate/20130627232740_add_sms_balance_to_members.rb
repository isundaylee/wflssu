class AddSmsBalanceToMembers < ActiveRecord::Migration
  def change
    add_column :members, :sms_balance, :integer
  end
end
