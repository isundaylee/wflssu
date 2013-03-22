class NotificationsController < ApplicationController
  around_filter :rescue_record_not_found

  def visit
    notification = Notification.find(params[:id])

    notification.state = Notification::READ_STATE
    notification.save

    redirect_to notification.link
  end
end
