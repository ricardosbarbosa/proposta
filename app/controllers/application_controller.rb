class ApplicationController < ActionController::Base
  protect_from_forgery
  
   # This is our new function that comes before Devise's one
  before_filter :authenticate_user_from_token!
  # This is Devise's authentication
  # before_filter :authenticate_user!

  before_filter { |c| Authorization.current_user = c.current_user }
 
  private
  
  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)
 
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: true
    end
  end

  protected

  def permission_denied
    flash[:error] = "Desculpe, você não tem permissão para acessar essa página."
    redirect_to root_url
  end
end
