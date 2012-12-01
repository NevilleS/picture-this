class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Application configuration
  APPID = "124425631049732"
  SECRET = "d59961eaa65bfa35f31b55f36db66280"

  # Logout of the application
  def logout
    session[:access_token] = nil
    flash[:notice] = "Logged out"
    redirect_to welcome_index_path
  end

  # Get the access token from the session
  def access_token
    return session[:access_token]
  end

  # Test if a user is logged in
  def access_token?
    return !current_user.nil?
  end
end
