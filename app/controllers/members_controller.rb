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
    new_privilege = params[:member][:privilege].to_i

    if new_privilege != @member.privilege && new_privilege >= current_member.privilege
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

  def search
    def process_token(token, partial)
      # Splitting the token
      tokens = token.split(':')

      # Extracting the search method, defaulting to searching by ID
      method = tokens.size >= 2 ? tokens[0] : 'id'
      method.downcase!

      # Reassembling the search query
      query = tokens.size >= 2 ? tokens[1 ... tokens.size].join(':') : tokens.join(':')

      if method == 'id'
        id = query.to_i
        partial = partial.where(code_number: id)
        logger.debug('Parsing as ID ' + id.to_s)
      elsif method == 'name'
        name = query
        partial = partial.where('name like ?', "%#{name}%")
      elsif method == 'class'
        class_number = query.to_i
        partial = partial.where(class_number: class_number)
      elsif method == 'year'
        year = query.to_i
        partial = partial.where(admission_year: year)
      elsif method == 'department'
        dep_name = query
        departments = Department.where('name like ?', "%#{dep_name}%")
        partial = partial.where(department_id: departments.collect { |d| d.id })
      else
        # No matching search method
        # Conjuring up a never-matching WHERE clause
        # Or should it simply be ignored? _TODO_
        partial = partial.where(id: -1)
      end

      # Result
      partial
    end

    # Obtaining the query string
    query = params[:query]

    # Splitting the query string into search tokens
    tokens = query.split(/\band\b/).collect { |t| t.strip }

    # Initialize result
    partial = Member

    # Process individual tokens
    tokens.each do |t|
      partial = process_token(t, partial)
    end

    # Assign results
    @members = partial.all
  end

  def member_by_code_number
    code_number = params[:code_number]

    user = Member.where('code_number = ?', code_number).first

    if user
      redirect_to user
    else
      flash[:error] = "There is no member with ID #{code_number}. "
      redirect_to root_url
    end
  end

  private

end
