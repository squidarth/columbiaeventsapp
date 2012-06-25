class EventsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  respond_to :json, :xml
  before_filter :determine_scope, only: [:upcoming, :recent]
  before_filter :parse_options, only: [:upcoming, :recent]

  def show
    @event = Event.find_by_id(params[:id], conditions: { deleted: [nil, false] }) || []
    render 'show'
  end

  def upcoming
    @events = @scope.find_all_upcoming @datetime, @options
    render 'index'
  end

  def recent
    @events = @scope.find_all_recent @datetime, @options
    render 'index'
  end

  def search
    @title = "Search"
    if params[:search].empty?
      redirect_to events_path
    else
      @header = "Search results for '" + params[:search] + "'"
      @events = @scope.search(params[:search])
    end
  end

  def pull
    event_id = params[:url].split("eid=")[1]
    category = params[:category][0].to_i
    Event.make_from_facebook(event_id, '', category)
    flash[:success] = "Event Successfully Pulled!"
    redirect_to '/events/new/'
  end

  def new
    @event = Event.new
    @user = current_user
    @title = "Create Event"
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

  def edit
    @event = Event.find(params[:id])
    @title = "Edit " + @event.name
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

  def parse_options
    @options = params.symbolize_keys.reject { |k| not [:limit, :offset].include?(k) }
    @options[:limit] ||= 10
    @datetime = params[:datetime] || DateTime.now
  end

  def determine_scope
    return @scope = Event unless params[:category_id]
    if not Category.exists?(params[:category_id])
      flash[:error] = 'Category does not exist!'
      return @scope = Event
    end
    @category = Category.find(params[:category_id])
    @scope = @category.events

    @title = @category.name
    flash[:notice] = 'Searching for events tagged: ' + @category.name
  end

end
