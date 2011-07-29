class AuthorizationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end
  
  def create
    auth  = request.env["omniauth.auth"]
    current_user.authorizations.create(:provider => auth['provider'], :uid => auth['uid'])
    redirect_to current_user
    
    #flash[:notice] = "Authentication successful."
    #redirect_to authentications_url
  end
  
  def destroy
    @authorization= current_user.authentications.find(params[:id])
    @authorization.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authorizations_url
  end


end