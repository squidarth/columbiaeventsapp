class AttendingsController < ApiController
  def index
    attendings = params[:event_id] ? Attending.find_all_by_event_id(params[:event_id]) : Attending.all
    respond_with attendings, api_template: :public
  end

  def index_for_user
    user_id = params[:user_id] || current_user.id
    attendings = User.find(user_id).attendings
    respond_with attendings, api_template: :events
  end

  def show
    attending = Attending.find_by_id(params[:id])
    respond_with attending, api_template: :public
  end

  def create
    event_id = params[:event_id] || params[:attending][:event_id]
    attending = Attending.find_or_create_by_user_id_and_event_id(current_user.id, event_id) do |u|
      u.status = params[:attending][:status] || 'YES'
    end
    respond_with attending, api_template: :public
  end

  def update
    attending = Attending.find params[:id]
    attending.update_attributes params[:attending] 
    respond_with attending, api_template: :public
  end
end
