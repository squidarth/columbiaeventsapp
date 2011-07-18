class CommentsController < ApplicationController
  
    def create
      @comment = Comment.create!(params[:comment])
      @event = Event.find_by_id(@comment.event_id)
         respond_to do |format|
           if @comment.save
             format.html { redirect_to @event }
             format.js 
          end
         end  
   end
end