class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index]
  before_filter :correct_user, :only => [:edit, :update]
   
   def index
     @title = "All users"
     @users = User.all
   end  
   def show
     @user = User.find(params[:id])
     @title = @user.name
     @events = @user.events
     @event = Event.new if signed_in?
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