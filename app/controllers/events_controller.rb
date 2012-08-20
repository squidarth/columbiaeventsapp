class EventsController < ApiController
  include EventsHelper

  before_filter :authenticate, only: [:create, :fetch_from_facebook, :destroy]
  before_filter :authorized_user, only: [:update, :destroy]

  before_filter :determine_scope, only: [:index, :upcoming, :recent]
  before_filter :parse_options, only: [:index, :upcoming, :recent]

  def index
    upcoming = @scope.includes(:categories, attendings: :user).upcoming(@datetime)
    recent = @scope.includes(:categories, attendings: :user).recent(@datetime)
    listing = EventListing.new({
      upcoming: upcoming.page(params[:page]).per(params[:per_page]),
      recent: recent.page(params[:page]).per(params[:per_page])
    })
    respond_with listing, api_template: :public, meta: { upcoming_count: upcoming.count, recent_count: recent.count }
  end

  def show
    event = Event.find(params[:id], conditions: { deleted: [nil, false] })
    respond_with event, api_template: :public
  end

  def upcoming
    events = @scope.upcoming(@datetime).page(params[:page]).per(params[:per_page])
    respond_with events, api_template: :public
  end

  def recent
    events = @scope.recent(@datetime).page(params[:page]).per(params[:per_page])
    respond_with events, api_template: :public
  end

  def fetch_from_facebook
    if current_user && params[:facebook_id]
      current_user.authorizations.find_by_provider('facebook').fetch_event_from_facebook_by_id params[:facebook_id]
    end
    event = Event.find_by_facebook_id params[:facebook_id]
    respond_with event, api_template: :public
  end

  def create
    event = current_user.events.build(params[:event])
    if event.save
      authorization = current_user.authorizations.find_by_provider 'facebook'
      if params[:post_to_facebook] and authorization
        graph = Koala::Facebook::API.new authorization.token
        params = {
          picture: event.photo.url,
          name: event.name,
          description: event.description,
          location: event.location,
        }
        facebook_event = graph.put_object('me', 'events', params)
        event.update_attributes!(facebook_id: facebook_event['id'])
      end
    end
    respond_with event, api_template: :public
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
                  picture: picture,
                  :name => @event.name,
                  :description => @event.description,
                  :location => @event.location,
                  start_time: datetime,
                }
              elsif(!@event.photo.nil?) #CASE THAT PHOTO EXISTS, NO DATETIME
                picture = Koala::UploadableIO.new(open(@event.photo.url(:small)).path, 'image')
                params = {
                  picture: picture,
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
                  start_time: datetime,
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
          format.html { redirect_to(@event, notice: 'Event was successfully updated.') }
          format.xml { head :ok }
        else
          format.html { render action: "edit" }
          format.xml { render :xml => @event.errors, status: :unprocessable_entity }
        end
      else
        if @event.update_attributes(params[:event])
          format.html { redirect_to(@event, notice: 'Event successfully updated.')}
          format.xml {head :ok}
        else
          format.html { render action: "edit" }
          format.xml { render :xml => @event.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    respond_with @event.destroy, api_template: :public
  end

  protected

  def has_photo?
    self.photo.url == "/photos/original/missing.png"
  end
  def authorized_user
    @event = current_user.events.find_by_id(params[:id])
    redirect_to root_path if @event.nil?
  end

  def parse_options
    @datetime = params[:datetime] ? params[:datetime].to_datetime : DateTime.now
  end

  def determine_scope
    # [TODO] merge both filters
    if params[:user_id]
      @scope = User.find(params[:user_id]).attending_events
    elsif params[:category_id]
      @scope = Category.find(params[:category_id]).events
    else
      @scope = Event
    end
    if params[:search]
      @scope = @scope.search(params[:search])
    end
  end
end
