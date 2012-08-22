class UsersController < ApiController
  def index
    users = User.page(params[:page]).per(params[:per_page])
    respond_with users, api_template: :public, root: :users
  end

  def show
    user = User.find params[:id] 
    respond_with user.as_api_response :public, current_user: current_user
  end

  def create
    user = User.create params[:user] 
    respond_with user, api_template: :public
  end

  def update
    user = User.find params[:id]
    authorize! :update, user
    user.update_attributes params[:user] if user
    respond_with user, api_template: :public
  end
end
