class EventsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  before_filter :determine_scope, only: [:index]

  def index
    if params[:search]
      @title = "Search"

      @array_of_events = @scope.search(params[:search])
      if params[:search].eql?("")
        @header = "No results"
        @array_of_events = []
      else
        @header = "Search results for '" + params[:search] + "'"
        @array_of_events
      end
    elsif params[:date]
      date = Date.parse(params[:date])
      @array_of_events = @scope.find_by_date(date)
      @header = I18n.l date, format: :long
      @header = @months[Date.parse(params[:date]).month - 1] + ' ' + Date.parse(params[:date]).day.to_s + ', ' + Date.parse(params[:date]).year.to_s 
    else
      @title = "All Events"
      @header = "All Events"
      @array_of_events = @scope.all limit: 10
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

  def show
    @attending = Attending.new
    @event = Event.find(params[:id])
    if(@event.deleted)
      redirect_to root_path
    end
    if(@event.facebooklink)
      @attendings = Event.get_fb_attendings(@event.facebooklink)
      @maybes = Event.get_fb_maybes(@event.facebooklink)
    end
    if current_user && current_user.facebookid && @event.facebooklink
      @friends = @event.check_friends(current_user)
    end
    session[:event_id] = @event.id
    @title = @event.name
  end

  def new
    @event = Event.new
    @user = current_user
    @title = "Make New Event!"
  end

  def edit
    @event = Event.find(params[:id])
    @title = "Edit " + @event.name
  end

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

  def destroy
    @event.destroy
    respond_to do |format|
      format.html {redirect_to current_user}
      format.js
    end
  end

  protected

  def authorized_user
    @event = current_user.events.find_by_id(params[:id])
    redirect_to root_path if @event.nil?
  end

  def determine_scope
    return @scope = Event unless params[:category_id]
    if not Category.exists?(params[:category_id])
      flash[:error] = 'Category does not exist!'
      return @scope = Event
    end
    @category = Category.find(params[:category_id])
    @title = @category.name
    flash[:notice] = 'Searching for events tagged: ' + @category.name
    @scope = @category.events
  end

end
