class UsersController < ApplicationController
   
   def index
     @users = User.all
   end  
   def show
     @user = User.find(params[:id])
     @title = @user.name
   end
   
   def new
     @title = "Sign up"
     @user = User.new
   end
   
   
   def create
    @user = User.new(params[:user])

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
end