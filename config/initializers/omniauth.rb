Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env == 'development'
    provider :facebook, '469594666399515', '60e615ca3dddc80ec2acd3b0a93ebd13', {:scope => 'email, create_event, offline_access, rsvp_event, user_events'}
    ENV['facebook_app_token'] = '469594666399515|FMe8SoVCi7_1cHq4S4Bs4jVoRlw'
  else
    provider :facebook, '469594666399515', '60e615ca3dddc80ec2acd3b0a93ebd13', {:scope => 'email, create_event, offline_access, rsvp_event, user_events'}
    ENV['facebook_app_token'] = '469594666399515|FMe8SoVCi7_1cHq4S4Bs4jVoRlw'
    #provider :facebook, '263515600329607', '2649d032a1ca0e33122e3614184ad18c', {:scope => 'email, create_event, offline_access, rsvp_event, user_events'}
  end
end
