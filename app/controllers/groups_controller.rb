class GroupsController < ApiController
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
    group = Group.find params[:id] 
    authorize! :update, group
    group.update_attributes params[:group] if group
    respond_with group, api_template: :public
  end
end
