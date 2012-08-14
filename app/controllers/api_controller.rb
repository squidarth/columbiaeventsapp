class ApiController < ApplicationController
  self.responder = ActsAsApi::Responder
  respond_to :json, :xml

  before_filter :default_params

  protected

  def default_params
    params[:page] ||= 1
    params[:per_page] ||= 25
  end
end
