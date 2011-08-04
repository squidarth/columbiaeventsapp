class EventsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  # GET /events
  # GET /events.xml
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    @comment = @event.comments.build(:event_id => :id)
    session[:event_id] = @event.id
    @comments = @event.comments.reverse
    @times = ['12:00 AM', '1:00 AM','2:00 AM', '3:00 AM','4:00 AM','5:00 AM', '6:00 AM','7:00 AM','8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM', '11:00 PM']
    @categories = ['Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council']
    @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

    #respond_to do |format|
     # format.html # show.html.erb
      #format.xml { render :xml => @event }
    #end
  end

  # GET /events/new
  # GET /events/new.xml

  # GET /events/1/edit
  def new
    @event = Event.new
    @user = current_user
  end
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = current_user.events.build(params[:event])
    if @event.save
      flash[:success] = "Event created!"
      
      #changed year to 2011 @event.date.year
      datetime = Time.mktime(@event.date.cwyear, @event.date.month, @event.date.day, @event.time.hour, @event.time.min)
      if !current_user.authorizations.empty?
        @graph = Koala::Facebook::GraphAPI.new(current_user.authorizations.find_by_provider('facebook').token)  
        picture = Koala::UploadableIO.new(@event.photo.url(:small))
        params = {
            :picture => picture,
            :name => 'Event name',
            :description => 'Event description',
            :start_time => datetime,
           }
        
        @graph.put_object('me', 'events', params )
      end
      redirect_to @event
    else
      redirect_to @event.user
    end
    
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event.destroy
    flash[:success] = "Event deleted!"
    redirect_to current_user
  end
  
  private
  
    def authorized_user
      @event = current_user.events.find_by_id(params[:id])
      redirect_to root_path if @event.nil?
    end
end
