class AdminController < ApplicationController
  before_filter :authorize
  def main
    @events = Event.all
  end
  
  def update
    @event = Event.find(params[:id])
    @event.update_attributes!(:category => params[:category])
    redirect_to admin_path
  end
 
  
  def create
    @id = params[:id]
    Event.make_from_facebook(@id, params[:author], params[:category])
    redirect_to admin_path
  end

  def destroy
    @event = Event.find(params[:id])
    @event.deleted = true
    @event.date = nil
    @event.save!
    redirect_to admin_path
  end
  
  private
  
  def authorize
    if signed_in?
      if(!current_user.email.eql?('sps2133@columbia.edu') && !current_user.email.eql?('akshay_shah91@hotmail.com'))
        redirect_to :root
      end
    else
      redirect_to :root  
    end
  end
end
