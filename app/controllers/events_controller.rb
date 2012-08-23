require 'chronic'

class EventsController < ApiController
  include EventsHelper

  before_filter :determine_scope, only: [:index, :upcoming, :recent]
  before_filter :parse_options, only: [:index, :upcoming, :recent]

  def index
    upcoming = @scope.includes(:categories, attendings: :user).upcoming(@datetime)
    recent = @scope.includes(:categories, attendings: :user).recent(@datetime)
    listing = EventListing.new({
      upcoming: upcoming.page(params[:page]).per(params[:per_page]),
      recent: recent.page(params[:page]).per(params[:per_page])
    })
    respond_with listing.as_api_response :public, current_user: current_user
  end

  def show
    event = Event.find(params[:id], conditions: { deleted: [nil, false] })
    respond_with event.as_api_response :public, current_user: current_user
  end

  def fetch_from_facebook
    authorize! :create, Event
    if current_user && params[:facebook_id]
      current_user.authorizations.find_by_provider('facebook').fetch_event_from_facebook_by_id params[:facebook_id]
    end
    event = Event.find_by_facebook_id params[:facebook_id]
    respond_with event, api_template: :public
  end

  def create
    authorize! :create, Event
    params[:event][:start_time] = Chronic.parse("#{params[:event][:date]} #{params[:event][:time]}").to_datetime
    event = current_user.events.build(params[:event])
    if event.save && params[:event][:post_to_facebook] 
      authorization = current_user.authorizations.find_by_provider 'facebook'
      if authorization
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
    event = Event.find(params[:id])
    authorize! :update, event
    params[:event][:start_time] = Chronic.parse("#{params[:event][:date]} #{params[:event][:time]}").to_datetime
    # [TODO] Make updating Facebook events functional, with notification
    if event.update_attributes(params[:event]) && event.facebook_id.presence
      authorization = current_user.authorizations.find_by_provider 'facebook'
      if authorization
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

  def destroy
    event = Event.find params[:id]
    authorize! :destroy, event
    event.update_attributes!(deleted: true)
    respond_with event, api_template: :public
  end

  protected

  def has_photo?
    self.photo.url == "/photos/original/missing.png"
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
