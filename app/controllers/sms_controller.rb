class SmsController < ApplicationController

  around_filter :rescue_record_not_found
  before_filter :require_membership, only: [:index, :transfer, :send_message]

  def index
  end

  def transfer
    target = Member.find(params[:target])
    amount = params[:amount].to_i

    if amount > current_member.sms_balance
      flash[:error] = I18n.t('sms.transfer.flash_insufficient_balance')
    else 
      target.sms_balance += amount
      target.save
      current_member.reload
      current_member.sms_balance -= amount
      current_member.save
      sign_in current_member
      flash[:success] = I18n.t('sms.transfer.flash_success', target: target.name, amount: amount)
    end

    redirect_to sms_index_path
  end

  def send_message
  end
end
