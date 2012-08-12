class AttendingsController < ApplicationController
  def index
    @attendings = Attending.all
    respond_with @attendings, api_template: :public
  end

  def show
    @attending = Attending.find_by_id(params[:id])
    respond_with @attending, api_template: :public
  end
  
  def attend
    @no_change = false
    Attending.all.each do |attending|
      if(attending.user_id.to_s.eql?(params[:attending][:user_id].to_s) && attending.event_id.to_s.eql?(params[:attending][:event_id].to_s))
        if(attending.status.eql?(params[:attending][:status]))
          @no_change = true
        end   
        attending.destroy
      end
    end
    @attending = Attending.create(params[:attending])
    respond_to do |format|
      @event = Event.find(@attending.event_id)
      format.html { redirect_to @event }
      format.js
    end 
  end

  def maybe
    @no_change = false;
    Attending.all.each do |attending|
      if(attending.user_id.to_s.eql?(params[:attending][:user_id].to_s) && attending.event_id.to_s.eql?(params[:attending][:event_id].to_s))
        if(attending.status.eql?(params[:attending][:status].to_s))
          @no_change = true;
        end
        attending.destroy
      end
    end
    @attending = Attending.create(params[:attending])
    respond_to do |format|
      @event = Event.find(@attending.event_id)
      format.html { redirect_to @event}
      format.js
    end     
  end
end
