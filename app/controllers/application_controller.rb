class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  rescue_from CanCan::AccessDenied do |exception|
    head :forbidden
  end
  # check_authorization # Uncomment to enforce authorize! on all actions

  def current_ability
    current_user.ability
  end
end
