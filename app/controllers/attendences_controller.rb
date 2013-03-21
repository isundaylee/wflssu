class AttendencesController < ApplicationController
  # around_filter :rescue_record_not_found

  def accept
    attendence = Attendence.find(params[:id])

    # do not use direct require_vice_dpresident to avoid double render
    return insufficient_privilege unless signed_in_as_vice_dpresident?(attendence.member.department)

    name = attendence.member.name
    attendence.accept

    flash[:success] = I18n.t('attendences.accept.flash_success', name: name)
    redirect_back
  end

  def reject
    attendence = Attendence.find(params[:id])

    # do not use direct require_vice_dpresident to avoid double render
    return insufficient_privilege unless signed_in_as_vice_dpresident?(attendence.member.department)

    name = attendence.member.name
    attendence.reject

    flash[:success] = I18n.t('attendences.reject.flash_success', name: name)
    redirect_back
  end

  def destroy
    attendence = Attendence.find(params[:id])

    # do not use direct require_vice_dpresident to avoid double render
    return insufficient_privilege unless signed_in_as_vice_dpresident?(attendence.member.department)
    
    name = attendence.member.name
    attendence.destroy
    flash[:success] = I18n.t('attendences.destroy.flash_success', name: name) 
    redirect_back
  end

end
