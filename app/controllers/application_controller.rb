# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  include SessionsHelper
  include ApplicationHelper

  LOCALES = {
    'en' => 'English',
    'zh' => '简体中文'
  }

  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] if session[:locale]
    @flash = {}
    @flash[:success] = I18n.t('application.set_locale.flash_success', locale_name: LOCALES[session[:locale]]) if params[:locale]
  end

  private

    def store_location
      session[:return_to] = request.fullpath
    end

    def redirect_back(default = root_url)
      redirect_to session[:return_to] || default
    end
end
