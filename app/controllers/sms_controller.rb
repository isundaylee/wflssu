class SmsController < ApplicationController

  around_filter :rescue_record_not_found
  before_filter :require_membership, only: [:index, :transfer, :send_message]

  MAX_SIMULTANEOUS_MESSAGES = 100
  MAX_MESSAGE_LENGTH = 65

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
    content = params[:content] || ''
    targets = params[:targets] || []

    if content.nil? or content.empty?
      flash[:error] = I18n.t('sms.send_message.flash_content_empty')
    elsif content.length > MAX_MESSAGE_LENGTH
      flash[:error] = I18n.t('sms.send_message.flash_message_too_long')
    elsif targets.empty? 
      flash[:error] = I18n.t('sms.send_message.flash_no_targets')
    elsif (targets.size > MAX_SIMULTANEOUS_MESSAGES)
      flash[:error] = I18n.t('sms.send_message.flash_too_many_targets')
    elsif (targets.size > current_member.sms_balance)
      flash[:error] = I18n.t('sms.send_message.flash_insufficient_balance')
    else
      error = post_message(targets, content)

      if error
        Rails.logger.error("SMS failure: #{error}")
        flash[:error] = I18n.t('sms.send_message.flash_api_error')
      else
        current_member.reload
        current_member.sms_balance -= targets.size
        current_member.save
        sign_in current_member
        flash[:success] = I18n.t('sms.send_message.flash_success')
        redirect_to sms_index_path
        return
      end
    end

    @content = params[:content]
    @targets = params[:targets]

    render 'index'
  end

  private

    def post_message(targets, content)
    end
end
