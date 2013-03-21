class EventsController < ApplicationController

  before_filter :require_vice_president, only: [:create, :new, :edit, :update, :destroy, :all_attend]
  before_filter :require_membership, only: [:index, :attend]

  def all_attend
    event = Event.find(params[:id])
    Member.all.each do |member|
      member.attend(event)
    end
    flash[:success] = I18n.t('events.all_attend.flash_success', title: event.title)
    redirect_back
  end

  def attend
    event = Event.find(params[:id])
    member = current_member
    if member.has_attended? event
      flash[:warning] = I18n.t('events.attend.already_attended', title: event.title)
      redirect_back
    else
      member.attend event
      flash[:success] = I18n.t('events.attend.flash_success', title: event.title)
      redirect_back
    end
  end

  def index
    @events = Event.all
    store_location
  end

  def new
    @event = Event.new
    @event.on_date = Date.today
  end

  def create
    @event = Event.new(params[:event])

    if @event.save then
      flash[:success] = I18n.t('events.create.flash_success', title: @event.title)
      redirect_to events_url
    else
      render 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(params[:event])
      flash[:success] = I18n.t('events.update.flash_success', title: @event.title)
      redirect_to events_url
    else
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:success] = I18n.t('events.destroy.flash_success', title: @event.title)
    redirect_to events_url
  end
end
