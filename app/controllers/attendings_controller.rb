class AttendingsController < ApiController
  include EventsHelper

  def index_for_user
    user_id = params[:user_id] || current_user.id
    attending_events = User.find(user_id).attending_events.includes(:categories, attendings: :user)
    listing = EventListing.new({
      upcoming: attending_events.upcoming.page(params[:page]).per(params[:per_page]),
      recent: attending_events.recent.page(params[:page]).per(params[:per_page])
    })
    respond_with listing.as_api_response :public, current_user: current_user
  end

  def show
    attending = Attending.find_by_id(params[:id])
    respond_with attending, api_template: :public
  end

  def create
    event_id = params[:event_id] || params[:attending][:event_id]
    attending = Attending.find_or_create_by_user_id_and_event_id(current_user.id, event_id) do |u|
      u.status = params[:attending][:status] || 'attending'
    end
    respond_with attending, api_template: :public
  end

  def update
    attending = Attending.find params[:id]
    attending.update_attributes params[:attending] 
    respond_with attending, api_template: :public
  end
end
