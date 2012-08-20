class UsersController < ApiController
  before_filter :authenticate, only: [:update, :index]
  before_filter :correct_user, only: [:update]

  def index
    users = User.page(params[:page]).per(params[:per_page])
    respond_with users, api_template: :public, root: :users
  end

  def show
    user = User.find params[:id] 
    respond_with user, api_template: :public, location: user_path(user)
  end

  def create
    user = User.create params[:user] 
    respond_with user, api_template: :public
  end

  def update
    user = User.find params[:id] 
    user.update_attributes params[:user] 
    respond_with user, api_template: :public
  end

  private

  def correct_user
    @user = User.find(params[:id])
    @user = nil unless current_user?(@user)
  end
end
