class TagsController < ApplicationController
  
  
  def create
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to admin_path}
      format.js
    end  
  end

end
