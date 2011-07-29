class AuthorizationsController < ApplicationController
  def index
    @authorizations = current_user.authorizations if current_user
  end
  
  def create
   render :text => request.env["omniauth.auth"]
   #auth  = request.env["omniauth.auth"]
    #authorization = Authorization.find_by_provider_and_uid(auth['provider'], auth['uid'])
 #   if authorization #case that an authorizaiton is found, sign in user
  #    sign_in(authorization.user)
   #   redirect_to(authorization.user)
   # elsif current_user
    #  current_user.authorizations.create!(:provider => auth['provider'], :uid => auth['uid'])
     # redirect_to current_user
    #else
     # user = User.new
      #user.authorizations.build(:provider => auth['provider'], :uid => auth['uid'])
   #   if user.save!
    #    sign_in user
     #   redirect_to user
    #  else
     #   session[:auth]  = auth.except('extra')
      #  redirect_to sign_up
     # end
  #  end

  end
  
  def destroy
    @authorization= current_user.authentications.find(params[:id])
    @authorization.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authorizations_url
  end


end