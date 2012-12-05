class MembersController < ApplicationController
  QRCODE_DEFAULT_SIZE = 150

  around_filter :rescue_record_not_found
  before_filter :require_vice_president, only: [:new, :create, :edit, :upate, :destroy]
  before_filter :require_membership, only: [:index]

  def new
    @member = Member.new
    
    if params[:department_id]
      @department = Department.find(params[:department_id])
      @member.department = @department
    end
  end

  def create
    @member = Member.new(params[:member])

    if @member.privilege >= current_member.privilege
      logger.debug '#'*20
      logger.debug @member.privilege
      @flash = {} 
      @flash[:error] = "You don't have sufficient privilege. "
      render 'new'
    elsif @member.save 
      flash[:success] = "You have successfully created new member #{@member.name}. "
      if @member.birthday.nil?
        flash[:warning] = "The newly created member has no birthday profile. This may result from an incorrectly formed birthday input. "
      end
      redirect_to member_url(@member)
    else
      render 'new'
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    is_current = true if params[:id].to_i == current_member.id

    if params[:member][:privilege].to_i >= current_member.privilege
      @flash = {}
      @flash[:error] = "You don't have sufficient privilege. "
      render 'edit'
    elsif @member.update_attributes(params[:member])
      flash[:success] = "You have successfully updated profile for #{@member.name}. "
      flash[:warning] = "The updated member has no birthday profile. This may result from an incorrectly formed birthday input. " if @member.birthday.nil?
      sign_in @member if is_current
      redirect_to member_url(@member)
    else
      render 'edit'
    end
  end

  def index
    if params[:department_id]
      @members = Member.where({department_id: params[:department_id]}).all
      @department = Department.find(params[:department_id])
    else
      @members = Member.all
    end
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    flash[:success] = "You have successfully deleted #{@member.name}. "
    redirect_to members_url
  end

  def qrcode
    require 'cgi'
    size = params[:size] || QRCODE_DEFAULT_SIZE 
    @member = Member.find(params[:id])
    text = "http://www.wflssu.com/proxy.php?action=su_show_user&id=#{@member.code_number}"
    url = "http://api.qrserver.com/v1/create-qr-code/?size=#{size}x#{size}&data=#{CGI.escape(text)}"
    redirect_to url
  end

  def show
    @member = Member.find(params[:id])
  end

  private

end
