class GroupController < ApplicationController
  before_filter :authenticate, only: [:create, :update]
  before_filter :correct_user, only: [:update]

  def index
    groups = Group.page(params[:page]).per(params[:per_page])
    respond_with groups, api_template: :public, root: :groups
  end

  def show
    group = Group.find params[:id] 
    respond_with group, api_template: :public, location: group_path(group)
  end

  def create
    group = Group.create params[:group] 
    respond_with group, api_template: :public
  end

  def update
    @group.update_attributes params[:group] if @group
    respond_with @group, api_template: :public
  end

  private

  def correct_user
    group = Group.find(params[:id])
    group = nil unless Group.users.find_by_user_id(current_user.id)
  end
end
