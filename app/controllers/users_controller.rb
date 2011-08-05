class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index]
  before_filter :correct_user, :only => [:edit, :update]
  
   
   def index
     @title = "All users"
     @users = User.all
   end  
   def show
     @user = User.find(params[:id])
     @times = ['12:00 AM', '1:00 AM','2:00 AM', '3:00 AM','4:00 AM','5:00 AM', '6:00 AM','7:00 AM','8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM', '11:00 PM']
     @categories = ['Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council']
     @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
     @title = @user.name
     @events = @user.events
     @event = Event.new if signed_in?
     @authorizations = @user.authorizations
   end
   
   def new
     @title = "Sign up"
     @user = User.new
   end
   
   
   def create
    @user = User.create(params[:user])

    if @user.save
       sign_in @user
       flash[:success] = "Thank you for joining!"
       redirect_to @user
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
    
    def update
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
        flash[:success] = "Profile updated"
        redirect_to @user
      else 
        @title = "Edit user"
        render 'edit'
      end
    end
    
    private
    

      
      def correct_user
          @user = User.find(params[:id])
          redirect_to(root_path) unless current_user?(@user)
      end
end