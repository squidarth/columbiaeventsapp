class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index]
  before_filter :correct_user, :only => [:edit, :update]


  def index
    if params[:search]
      if(params[:search].eql?(""))
        @users = []
        @title = "Search Users"
        @header = "No Results" 
      else
        @users = sort_alphabetically(User.search(params[:search]))
        @title = "Search Users"
        @header = "Search results for '" + params[:search] + "'"

      end

    else
      @title = "All Users"
      @header = "All Users"
      @users = sort_alphabetically(User.all)
    end
  end  

  def show
    @user = User.find(params[:id])
    @times = ['12:00 AM', '1:00 AM','2:00 AM', '3:00 AM','4:00 AM','5:00 AM', '6:00 AM','7:00 AM','8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM', '11:00 PM']
    @categories = ['Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council', 'Other']
    @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    @title = @user.name
    @array_of_events = [] #initialize array_of events
    @events = @user.events
    @events.each do |event| #get all events with dates
      if event.date
        @array_of_events << event
      end
    end
    @array_of_events.sort! {|a,b| b.date <=> a.date } #sort the events with dates
    @events.each do |event| #add on the events with no date
      if !event.date
        @array_of_events << event
      end
    end
    @event = Event.new if signed_in?
    @authorizations = @user.authorizations
  end

  # def new
  #  @title = "Sign up"
  # @user = User.new
  #hoend

  def confirm
    @user = User.find(params[:id])
    if(params[:confirmcode].eql?(@user.confirmcode))
      @user.confirmed = true
      @user.save
      sign_in @user
      flash[:success] = "You're all signed up! Either start by editing your profile to add some details, or go ahead and start creating events!"
      redirect_to @user
    else
      redirect_to :root
    end
  end

  def wait
  end

  def create
    @user = User.create(params[:user])
    @user.confirmcode = rand(99999999).to_s
    @user.confirmed = false
    if @user.save
      #sign_in @user
      #flash[:success] = "You're all signed up! Either start by editing your profile to add some details, or go ahead and start creating events!"
      #redirect_to @user
      UserMailer.registration_confirmation(@user).deliver
      redirect_to verify_path
    else
      @title = "Sign up!"
      render 'new'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to :root
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit User"
  end

  def changepassword
    @user = User.find(params[:id])
    @title = "Change password"  
  end

  def update
    @user = User.find(params[:id])
    if(params[:user][:password])
      @user.update_attributes(params[:user])
      flash[:success] = "Password Updated"
      redirect_to @user
    else
      #if @user.update_attributes!(:name => params[:user]["name"], :email => params[:user]["email"])
      email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      #figure out how to get user avatar
      if((params[:user][:email] =~ email_regex))
        @user.update_attribute(:name, params[:user][:name])
        @user.update_attribute(:email, params[:user][:email])
        @user.update_attribute(:school, params[:user][:school])
        @user.update_attribute(:aboutme, params[:user][:aboutme])

        if(params[:user][:avatar])
          @user.update_attribute(:avatar, params[:user][:avatar])
        end
        redirect_to @user
      else
        @email_error = "Please enter a valid email"
        render 'edit'
      end
    end
  end

  private


  def filter_and_sort_date(events)
    temp_events = events
    filtered_events = []
    temp_events.each do |event|
      if event.date
        if event.date >= Date.today
          filtered_events << event  
          temp_events.delete(event)
        end
      end
    end
    filtered_events.sort! {|a,b| a.date <=> b.date}

    other_events = []
    temp_events.each do |event|
      if event.date
        other_events << event
      end
    end
    other_events.sort! {|a,b| b.date <=> a.date}
    filtered_events += other_events
    temp_events.each do |event|
      if !event.date
        filtered_events << event
      end

    end
    filtered_events
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def sort_alphabetically(users)
    users.sort! {|a,b| a.name.downcase <=> b.name.downcase}
    users
  end
end
