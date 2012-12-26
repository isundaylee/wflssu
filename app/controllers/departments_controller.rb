class DepartmentsController < ApplicationController

  before_filter :require_vice_president, only: [:new, :create, :edit, :update, :index]

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(params[:department])

    if @department.save then
      flash[:success] = I18n.t('departments.create.flash_success', name: @department.name)   
      redirect_to departments_url 
    else
      render 'new'
    end

  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])

    if @department.update_attributes(params[:department])
      flash[:success] = I18n.t('departments.update.flash_success', name: @department.name)
      flash[:success] = "Successfully updated information for department #{@department.name}. "
      redirect_to departments_url
    else
      render 'edit'
    end
  end

  def index
    @departments = Department.all
  end
end
