class AuthorizationsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    #render :json => auth
    authorization = Authorization.find_by_provider_and_uid(auth['provider'], auth['uid'])

    if authorization #case that an authorizaiton is found, sign in user
      user = authorization.user
      authorization.update_attributes!(:token => auth['credentials']['token'])
      Event.get_events(auth['credentials']['token'])
      sign_in user
    elsif signed_in? #case that user is already signed into eventsalsa
      current_user.authorizations.create!(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
    else #case that new user needs to be created
      random_id = rand(99999999)
      user = User.create(:name => auth['extra']['raw_info']['first_name'] + " " + auth['extra']['raw_info']['last_name'], 
                         :email => auth['info']['email'], 
                         :fblink => auth['extra']['raw_info']['link'], 
                         :fbnickname => auth['info']['nickname'],
                         :password => random_id, :password_confirmation => random_id, 
                         :facebookid => auth['uid'])
      if user.save
        user.authorizations.create!(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
        sign_in user
        Event.get_events(auth['credentials']['token'])
        flash[:success] = "Thanks for joining! To get started either edit your profile or start creating events!"
      else
        session[:auth]  = auth.except('extra')
      end
    end
    redirect_to root_url
  end

  def destroy
    @authorization= current_user.authentications.find(params[:id])
    @authorization.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authorizations_url
  end
end
