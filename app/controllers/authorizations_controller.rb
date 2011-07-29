class AuthorizationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end
  
  def create
    auth  = request.env["omniauth.auth"]
    authorization = Authorization.find_by_provider_and_uid(auth['provider', auth['uid']])
    if authorization #case that an authorizaiton is found, sign in user
      sign_in(authentication.user)
      redirect_to(authentication.user)
    else
      current_user.authorizations.create(:provider => auth['provider'], :uid => auth['uid'])
      redirect_to current_user
    end

  end
  
  def destroy
    @authorization= current_user.authentications.find(params[:id])
    @authorization.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authorizations_url
  end


end