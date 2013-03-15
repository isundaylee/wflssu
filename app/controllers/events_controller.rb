class EventsController < ApplicationController

  before_filter :require_vice_president, only: [:create, :new, :edit, :update, :destroy]
  before_filter :require_membership, only: [:index]

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
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
