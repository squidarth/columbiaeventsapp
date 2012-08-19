class AuthorizationsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    #render :json => auth

    authorization = Authorization.find_by_provider_and_uid(auth['provider'], auth['uid'])

    if authorization #case that an authorization is found, sign in user
      puts 1
      user = authorization.user
      authorization.update_attributes!(:token => auth['credentials']['token'])
      sign_in user
    elsif signed_in? #case that user is already signed into eventsalsa
      puts 2
      current_user.authorizations.create!(:provider => auth['provider'],
                                          :uid => auth['uid'],
                                          :token => auth['credentials']['token'])
    else #case that new user needs to be created
      puts 3
      user = User.create(:name => "#{auth['extra']['raw_info']['first_name']} #{auth['extra']['raw_info']['last_name']}", 
                         :email => auth['info']['email'], 
                         :facebook_id => auth['uid'])
      if user.save
        user.authorizations.create!(:provider => auth['provider'],
                                    :uid => auth['uid'],
                                    :token => auth['credentials']['token'])
        .fetch_events_from_facebook
        sign_in user
      end
    end
    redirect_to root_url
  end
end
