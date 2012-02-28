class AttendingsController < ApplicationController


  def list
    @event = Event.find(params[:event_id])
    if(@event.facebooklink)
      @attendings = Event.get_fb_attendings(@event.facebooklink)
      @maybes = Event.get_fb_maybes(@event.facebooklink)
    else
      @attendings = @event.attendings.find_all_by_status("Attending")
      @maybes = @event.attendings.find_all_by_status("Maybe")

    end

    if current_user && current_user.facebookid && @event.facebooklink
    	@friends = @event.check_friends(current_user)
    end
    
    respond_to do |format|
      format.html
      format.js
    
    end

    

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
      format.html { redirect_to @event}
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
