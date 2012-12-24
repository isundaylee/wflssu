class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper
  include ApplicationHelper

  private

    def store_location
      session[:return_to] = request.fullpath
    end

    def redirect_back(default = root_url)
      redirect_to session[:return_to] || default
    end
end
