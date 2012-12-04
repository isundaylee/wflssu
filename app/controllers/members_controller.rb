class MembersController < ApplicationController

  around_filter :rescue_member_not_found

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(params[:member])

    if @member.save 
      flash[:success] = "You have successfully created new member #{@member.name}. "
      redirect_to members_url
    else
      render 'new'
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update_attributes(params[:member])
      flash[:success] = "You have successfully updated profile for #{@member.name}. "
      redirect_to members_url
    else
      render 'edit'
    end
  end

  def index
    @members = Member.all
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    flash[:success] = "You have successfully deleted #{@member.name}. "
    redirect_to members_url
  end

  def qrcode
    require 'cgi'
    size = params[:size] || 150
    @member = Member.find(params[:id])
    text = "http://www.wflssu.com/proxy.php?action=su_show_user&id=#{@member.code_number}"
    url = "https://chart.googleapis.com/chart?chs=#{size}x#{size}&cht=qr&chl=#{CGI.escape(text)}"
    redirect_to url
  end

  private

    def rescue_member_not_found
      yield
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Invalid member. "
      redirect_to members_url
    end
    
end
