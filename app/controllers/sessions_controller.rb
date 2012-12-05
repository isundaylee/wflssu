class SessionsController < ApplicationController
  def new
  end

  def create
    code_number = params[:session][:code_number]
    password = params[:session][:password]

    member = Member.find_by_code_number(code_number)

    @errors = []

    if !member
      @errors << 'Member with the given ID not found. '
      render 'new'
    else
      if member.authenticate(password)
        flash[:success] = "You have successfully logged in as #{member.name}. "
        sign_in member 
        redirect_to root_url
      else
        @errors << 'Incorrect password. '
        render 'new'
      end
    end
  end

  def destroy
    sign_out
    flash[:success] = 'You have successfully logged out. '
    redirect_to root_url
  end
end
