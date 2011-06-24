class EventsController < ApplicationController
  #before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  # GET /events
  # GET /events.xml
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    #respond_to do |format|
     # format.html # show.html.erb
      #format.xml  { render :xml => @event }
    #end
  end

  # GET /events/new
  # GET /events/new.xml

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = current_user.events.build(params[:event])
    if @event.save
      flash[:success] = "Event created!"
      redirect_to @event.user
    else
      redirect_to about_path
    end
    
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
    def authorized_user
      @event = current_user.events.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end
end
