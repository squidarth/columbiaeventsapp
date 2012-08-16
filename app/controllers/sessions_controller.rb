class SessionsController < ApiController
  def show
    if current_user
      respond_with current_user, api_template: :session
    else
      respond_with nil
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
