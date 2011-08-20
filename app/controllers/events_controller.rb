class EventsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  # GET /events
  # GET /events.xml
  def index
    if params[:search]
      @events = Event.search(params[:search])
      @array_of_events = []
      @events.each do |event| #possibly move this into the event model
        if event.date > Date.today || event.date == Date.today
          @array_of_events << event
        end
      end
    else
      @array_of_events = Event.all
    end
    @times = ['12:00 AM', '1:00 AM','2:00 AM', '3:00 AM','4:00 AM','5:00 AM', '6:00 AM','7:00 AM','8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM', '11:00 PM']
    @categories = ['Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council']
    @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
      
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
    @title = "Make New Event!"
  end
  def edit
    @event = Event.find(params[:id])
    @title = "Edit " + @event.name
  end

  # POST /events
  # POST /events.xml
  def create
    @event = current_user.events.build(params[:event])
    if @event.save
      flash[:success] = "Event created!"
      if(@event.facebookevent == 1)
        datetime = Time.mktime(@event.date.year, @event.date.month, @event.date.day, @event.time.hour, @event.time.min)
        if(!current_user.authorizations.empty?)
          current_user.authorizations.each do |authorization|
            if authorization.provider.eql?("facebook")
              @token = authorization.token
            end
          end
          @graph = Koala::Facebook::GraphAPI.new(@token)  
          require 'open-uri'
          OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
          OpenURI::Buffer.const_set 'StringMax', 0
          picture = Koala::UploadableIO.new(open(@event.photo.url(:small)).path, 'image')
          if(@event.date && @event.time)
               datetime = Time.mktime(@event.date.year, @event.date.month, @event.date.day, @event.time.hour, @event.time.min)
               params = {
              :picture => picture,
              :name => @event.name,
              :description => @event.description,
              :location => @event.location,
              :start_time => datetime,
             }
          else
           params = {
                :picture => picture,
                :name => @event.name,
                :description => @event.description,
                :location => @event.location,
               }
          end
          @event.facebooklink  = @graph.put_object('me', 'events', params )
          @event.save
        end
      end
      redirect_to @event
    else
      @title = "Make New Event!"
      render 'new'
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
  
  def search
    @array_of_events = Event.search(params[:search][:search])
    @times = ['12:00 AM', '1:00 AM','2:00 AM', '3:00 AM','4:00 AM','5:00 AM', '6:00 AM','7:00 AM','8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM', '11:00 PM']
    @categories = ['Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council']
    @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
      
  end
  
  private
  
    def authorized_user
      @event = current_user.events.find_by_id(params[:id])
      redirect_to root_path if @event.nil?
    end
end
