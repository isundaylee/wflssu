class SmsController < ApplicationController
  before_filter :require_membership, only: [:index, :transfer, :send_message]

  def index
  end

  def transfer
  end

  def send_message
  end
end
