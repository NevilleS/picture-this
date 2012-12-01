class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Application configuration
  APPID = "124425631049732"
  SECRET = "d59961eaa65bfa35f31b55f36db66280"

  # Other constants
  PT_KEYWORD = /PT_\w+/

  # Logout of the application
  def logout
    session[:access_token] = nil
    session[:current_user] = nil
    flash[:notice] = "Logged out"
    redirect_to welcome_index_path
  end

  # Get the access token from the session
  def access_token
    return session[:access_token]
  end

  # Test if a user is logged in
  def access_token?
    return !access_token.nil?
  end

  # Get the current user
  def current_user
    unless session[:user_id].nil?
      return User.find(session[:user_id])
    end
    return nil
  end

  # Test for the current user
  def current_user?
    return !current_user.nil?
  end

  # Get the user's friends
  def get_friends(access_token)
    graph = Koala::Facebook::API.new(access_token)
    return graph.get_connections("me", "friends")
  end
end
