class CommentsController < ApplicationController
  
    def create
      @event = Event.find_by_id(session[:event_id])
      session[:event_id] = nil
      @comment = @event.comments.build(params[:comment])
    #@comment = Event.find(params[:event]).comments.build(params[:comment])
    if @comment.save
      flash[:success] = "Comment sent!"
      redirect_to @comment.event
    else
      redirect_to @event
    end
    
  end
end