class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def registration_confirmation(user)
    recipients user.email
    from       "info@eventsalsa.com"
    subject    "Thank you for registering"
    body       :user => user
    
  end
end
