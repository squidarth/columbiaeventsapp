# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Sidsapp::Application.initialize!


#initialize Email with GoDaddy

config.action_mailer.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address  => "smtp.someserver.net",
  :domain => 'www.eventsalsa.com',
  :port  => 80,
  :user_name  => "info@eventsalsa.com",
  :password  => "virtus12",
  :authentication  => :plain
}