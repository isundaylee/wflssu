module SessionsHelper

  def sign_in(member)
    cookies.permanent[:remember_token] = member.remember_token
    self.current_member = member 
  end

  def signed_in?
    !self.current_member.nil?
  end

  def signed_in_with_privilege?(privilege)
    signed_in? and self.current_member.has_privilege_of? privilege
  end

  def signed_in_as_vice_president?
    signed_in_with_privilege? Member::VICE_PRESIDENT_PRIVILEGE
  end

  def signed_in_as_vice_dpresident?(department = nil)
    return false unless signed_in_with_privilege? Member::VICE_DPRESIDENT_PRIVILEGE
    return true if signed_in_with_privilege? Member::VICE_PRESIDENT_PRIVILEGE
    return false if (department and current_member.department != department)
    true
  end

  def require_membership
    insufficient_privilege unless signed_in?
  end

  def require_vice_president
    insufficient_privilege unless signed_in_as_vice_president?
  end

  def require_vice_dpresident(department = nil)
    insufficient_privilege unless signed_in_as_vice_dpresident?(department)
  end

  def sign_out
    self.current_member = nil
    cookies.delete(:remember_token)
  end

  def current_member=(member)
    @current_member = member 
  end

  def current_member
    @current_member ||= Member.find_by_remember_token(cookies[:remember_token])
  end

  private 

    def insufficient_privilege
      flash[:error] = I18n.t('helpers.sessions.insufficient_privilege.insufficient_privilege')
      redirect_to root_url
    end

end
