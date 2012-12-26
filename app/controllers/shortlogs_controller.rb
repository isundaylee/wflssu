class ShortlogsController < ApplicationController
  around_filter :rescue_record_not_found
  before_filter :require_vice_president, only: [:destroy]

  def destroy
    sl = Shortlog.find(params[:id]).destroy
    name = sl.member.name
    content = sl.content
    sl.destroy
    flash[:success] = I18n.t('shortlogs.destroy.flash_success', name: name, content: content)
    redirect_back
  end
end
