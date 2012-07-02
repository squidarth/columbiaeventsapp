class CategoriesController < ApplicationController
  respond_to :json, :xml

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by_id(params[:id])
  end
end
