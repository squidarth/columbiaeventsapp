class EventsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  # GET /events
  # GET /events.xml
  def index
    @categories = ['Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council', 'Other']
    @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    
    if params[:search]
      @title = "Search"

      @events = Event.search(params[:search])
      if params[:search].eql?("")
        @header = "No results"
        @array_of_events = []
      else
        @header = "Search results for '" + params[:search] + "'"
        @array_of_events = @events.sort!{|a,b| b.date <=> a.date }
      end
    elsif params[:date]
      @array_of_events = Event.find_by_date(Date.parse(params[:date]))
      @header = @months[Date.parse(params[:date]).month - 1] + ' ' + Date.parse(params[:date]).day.to_s + ', ' + Date.parse(params[:date]).year.to_s 
    else
      @title = "All Events"
      @header = "All Events"
      @array_of_events = Event.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @events }
    end
  end

  def pull
    event_id = params[:url].split("eid=")[1]
    category = params[:category][0].to_i
    Event.make_from_facebook(event_id, '', category)
    flash[:success] = "Event Successfully Pulled!"
    redirect_to '/events/new/'
  end
  
  def calendar
    @dates_with_events = []
    Event.all.each do |event|
      @dates_with_events << event.date
    end
    @events = Event.all
    @categories = ['Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council', 'Other']
    @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    @array_of_events = []
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    if(!params[:date])
      @events.each do |event|
        if(event.date == Date.today)
          @array_of_events << event
        end
      end
    elsif params[:date]
      @events.each do |event|
        if(event.date == Date.parse(params[:date]))
          @array_of_events << event
        end
      end
    end
    @array_of_events
  end
  # GET /events/1
  # GET /events/1.xml
  def show
    @attending = Attending.new
    @event = Event.find(params[:id])
    if(@event.facebooklink)
      @attendings = Event.get_fb_attendings(@event.facebooklink)
      @maybes = Event.get_fb_maybes(@event.facebooklink)
    end
    session[:event_id] = @event.id
    @times = ['12:00 AM', '1:00 AM','2:00 AM', '3:00 AM','4:00 AM','5:00 AM', '6:00 AM','7:00 AM','8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM', '11:00 PM']
       @categories = ['Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council', 'Other']
    @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    @title = @event.name
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
      @attending = @event.attendings.build(:event_id => @event.id, :user_id => current_user.id, :status => "Attending")
      @attending.save
      flash[:success] = "Event created!"
      if(@event.facebookevent == 1)
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
          #NEED TO HAVE SEPARATE SEND OPTIONS FOR PICTURE, NO PICTURE, DATE&TIME, NO DATE&TIME

          #CASE THAT PICTURE, DATE, TIME EXIST
          if(!@event.photo.url.eql?("/photos/original/missing.png") && @event.date && @event.time)
            picture = Koala::UploadableIO.new(open(@event.photo.url(:small)).path, 'image')
            datetime = Time.mktime(@event.date.year, @event.date.month, @event.date.day, @event.time.hour, @event.time.min)
            params = {
              :picture => picture,
              :name => @event.name,
              :description => @event.description,
              :location => @event.location,
              :start_time => datetime,
             }
          elsif(!@event.photo.url.eql?("/photos/original/missing.png")) #CASE THAT PHOTO EXISTS, NO DATETIME
            picture = Koala::UploadableIO.new(open(@event.photo.url(:small)).path, 'image')
            params = {
              :picture => picture,
              :name => @event.name,
              :description => @event.description,
              :location => @event.location,
             }
          elsif(@event.date && @event.time)
            datetime = Time.mktime(@event.date.year, @event.date.month, @event.date.day, @event.time.hour, @event.time.min)
            params = {
              :name => @event.name,
              :description => @event.description,
              :location => @event.location,
              :start_time => datetime,
             }
          else
            params = {
              :name => @event.name,
              :description => @event.description,
              :location => @event.location,
             }
          end
          require 'json'
          answer = @graph.put_object('me', 'events', params)
          @event.facebooklink = answer['id']
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
      #Changes that need to be made
      # 1.) Make sure that the Facebook event is changed as well
      # 2.) (Update all attributes of the field)
      if(@event.facebookevent == 0 || @event.facebookevent.nil?)
        if @event.update_attributes(params[:event])
          #how do i check that an event has been turned into a Facebook event?
          
          if(@event.facebookevent == 1) #CASE THAT EVENT HAS BEEN MADE FACEBOOK EVENT
            #SAVE THE EVENT AS A FACEBOOK EVENT
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
                      #NEED TO HAVE SEPARATE SEND OPTIONS FOR PICTURE, NO PICTURE, DATE&TIME, NO DATE&TIME
                      
                      #CASE THAT PICTURE, DATE, TIME EXIST
                      if(!@event.photo.nil? && @event.date && @event.time)
                        picture = Koala::UploadableIO.new(open(@event.photo.url(:small)).path, 'image')
                        datetime = Time.mktime(@event.date.year, @event.date.month, @event.date.day, @event.time.hour, @event.time.min)
                        params = {
                          :picture => picture,
                          :name => @event.name,
                          :description => @event.description,
                          :location => @event.location,
                          :start_time => datetime,
                         }
                      elsif(!@event.photo.nil?) #CASE THAT PHOTO EXISTS, NO DATETIME
                        picture = Koala::UploadableIO.new(open(@event.photo.url(:small)).path, 'image')
                        params = {
                          :picture => picture,
                          :name => @event.name,
                          :description => @event.description,
                          :location => @event.location,
                         }
                      elsif(@event.date && @event.time)
                        datetime = Time.mktime(@event.date.year, @event.date.month, @event.date.day, @event.time.hour, @event.time.min)
                        params = {
                          :name => @event.name,
                          :description => @event.description,
                          :location => @event.location,
                          :start_time => datetime,
                         }
                      else
                        params = {
                          :name => @event.name,
                          :description => @event.description,
                          :location => @event.location,
                         }
                      end
                      @event.facebooklink  = @graph.put_object('me', 'events', params )[:id]
                      @event.save
                    end
          end
          format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
          format.xml { head :ok }
          
        else
          format.html { render :action => "edit" }
          format.xml { render :xml => @event.errors, :status => :unprocessable_entity }
        end
      else
        if @event.update_attributes(params[:event])
          format.html { redirect_to(@event, :notice => 'Event successfully updated.')}
          format.xml {head :ok}
        else
          format.html { render :action => "edit" }
          format.xml { render :xml => @event.errors, :status => :unprocessable_entity }
        end
      end
   
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event.destroy
    respond_to do |format|
      format.html {redirect_to current_user}
      format.js
    end
  end
  
  
  private
  
def filter_and_sort_date(events)
        temp_events = events
        filtered_events = []
        temp_events.each do |event|
          if event.date
            if((event.date < (Date.today+3)) && (event.date >= Date.today) )
              filtered_events << event  
              temp_events.delete(event)
            end
          end
        end
        filtered_events.sort! {|a,b| a.date <=> b.date}
        
        other_events = []
        temp_events.each do |event|
          if event.date
             other_events << event
          end
        end
        other_events.sort! {|a,b| b.date <=> a.date}
        filtered_events += other_events
        temp_events.each do |event|
          if !event.date
            filtered_events << event
          end
        
        end
        filtered_events
  end
    
    def authorized_user
      @event = current_user.events.find_by_id(params[:id])
      redirect_to root_path if @event.nil?
    end
end
