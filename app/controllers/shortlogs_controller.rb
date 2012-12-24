class ShortlogsController < ApplicationController
  around_filter :rescue_record_not_found
  before_filter :require_vice_president, only: [:destroy]

  def destroy
    sl = Shortlog.find(params[:id]).destroy
    name = sl.member.name
    content = sl.content
    sl.destroy
    flash[:success] = "You have successfully deleted #{name}'s log message: #{content}"
    redirect_back
  end
end
