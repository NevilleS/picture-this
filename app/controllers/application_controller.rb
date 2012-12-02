class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Application configuration
  APPID = "124425631049732"
  SECRET = "d59961eaa65bfa35f31b55f36db66280"

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
    begin
      unless session[:user_id].nil?
        return User.find(session[:user_id])
      end
    rescue
      return nil
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

  # Get a person's first name
  def get_first_name(access_token, id)
    graph = Koala::Facebook::API.new(access_token)
    user = graph.get_object(id)
    if user
      return user["first_name"]
    end
    return nil
  end
  # Get a random template
  def get_random_template
    # TODO: random...?
    return Template.find(1)
  end
end
