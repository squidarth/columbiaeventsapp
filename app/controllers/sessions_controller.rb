class SessionsController < ApiController
  def show
    if current_user
      respond_with current_user, api_template: :session
    else
      respond_with nil
    end
  end

  def create
   user = User.authenticate(params[:session][:email], params[:session][:password])
      if user.nil?
        #create error message and re-render page
        @title = "Sign in!"
        @invalid = "Invalid Username/Password combination."
        render 'new'
      elsif !user.confirmed
        redirect_to verify_path
      else
      #sign in user
        flash[:success] = "Signed in!"
        sign_in user
        redirect_to user
      end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
