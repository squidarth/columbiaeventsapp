class AttendingsController < ApiController
  def index
    attendings = Attending.all
    respond_with attendings, api_template: :public
  end

  def show
    attending = Attending.find_by_id(params[:id])
    respond_with attending, api_template: :public
  end

  def attending
    attending = Attending.create params[:attending] 
    respond_with attending, api_template: :public
  end

  def update
    attending = Attending.find_or_create_by_user_id_and_event_id(current_user.id, params[:event_id]) do |u|

    end
    respond_with attending, api_template: :public
  end
end
