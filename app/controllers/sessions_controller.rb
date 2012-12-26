class SessionsController < ApplicationController
  def new
  end

  def create
    code_number = params[:session][:code_number]
    password = params[:session][:password]

    member = Member.find_by_code_number(code_number)

    @errors = []

    if !member
      @errors << I18n.t('sessions.create.member_with_given_id_not_found')
      render 'new'
    else
      if member.authenticate(password)
        flash[:success] = I18n.t('sessions.create.successfully_logged_in', name: member.name)
        sign_in member 
        redirect_to root_url
      else
        @errors << I18n.t('sessions.create.incorrect_password')
        render 'new'
      end
    end
  end

  def destroy
    sign_out
    flash[:success] = I18n.t('sessions.destroy.successfully_logged_out')
    redirect_to root_url
  end
end
