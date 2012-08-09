class ApiController < ApplicationController
  self.responder = ActsAsApi::Responder
  respond_to :json, :xml
end
