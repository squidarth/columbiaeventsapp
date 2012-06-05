class CategoriesController < ApplicationController

  def query
    @title = params[:query]
    @category = Category.find_by_name(@title)
  end

  #def events
    #@category = Category.find(params[:id])
    #if @category
      #@title = @category.name
      #flash[:notice] = 'Searching for events tagged: ' + @category.name
      #@array_of_events = @category.events :limit => 10
      #render 'events'
    #else
      #flash[:error] = 'Category does not exist!'
      #redirect_to events_path
    #end
  #end
end
