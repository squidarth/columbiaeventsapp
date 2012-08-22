class MembershipController < ApplicationController
  def index_for_group
    memberships = params[:group_id] ? Membership.find_all_by_group_id(params[:group_id]) : Membership.all
    respond_with memberships, api_template: :users
  end

  def index_for_user
    user_id = params[:user_id] || current_user.id
    memberships = User.find(user_id).memberships
    respond_with memberships, api_template: :groups
  end

  def show
    membership = Membership.find_by_id(params[:id])
    respond_with membership, api_template: :public
  end

  def create
    group_id = params[:group_id] || params[:membership][:group_id]
    membership = Membership.find_or_create_by_user_id_and_group_id(current_user.id, group_id) do |u|
      u.status = params[:membership][:status] || 'YES'
    end
    respond_with membership, api_template: :public
  end

  def update
    membership = Membership.find params[:id]
    membership.update_attributes params[:membership] 
    respond_with membership, api_template: :public
  end
end
