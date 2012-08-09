class CategoriesController < ApiController
  def index
    @categories = Category.all
    respond_with @categories, api_template: :public, root: :categories
  end

  def show
    @category = Category.find_by_id(params[:id])
    respond_with @category, api_template: :public
  end
end
