class AdminController < ApplicationController
  before_filter :authorize
  def main
    @events = Event.all
    @categories = [' ', 'Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council', 'Other', 'Cultural', 'Special Interest']
  end
  
  def update
    categories = [' ', 'Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council', 'Other', 'Cultural', 'Special Interest']
    @event = Event.find(params[:id])
    Tag.create!(:event_id => @event.id, :name => categories[params[:category].to_i])
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
      if(!current_user.admin)
        redirect_to :root
      end
    else
      redirect_to :root  
    end
  end
end
