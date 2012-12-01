class WelcomeController < ApplicationController
  def index
    if !access_token?
      redirect_to welcome_login_path
      return
    end
    @access_token = access_token

    if !current_user?
      # Get the user info
      @graph = Koala::Facebook::API.new(@access_token)
      @fbuser = @graph.get_object("me")
      @name = @fbuser["name"]
      @email = @fbuser["email"]
      @id = @fbuser["id"]

      # Find the user in our db
      @user = User.find_by_email(@email)
      if @user.nil?
        @user = User.new
        @user.name = @name
        @user.email = @email
        @user.facebook_id = @id
        @user.save
      end
      session[:user_id] = @user.id
    end
    @user = current_user
  end

  def login
    if access_token?
      redirect_to welcome_index_path
      return
    end

    # Send an oauth request to Facebook
    @oauth = Koala::Facebook::OAuth.new(APPID, SECRET, welcome_callback_url)
    @fb_login_url = @oauth.url_for_oauth_code(:permissions => "email,user_photos,friends_photos,publish_stream")
  end

  # Callback from Facebook API
  def callback
    @oauth = Koala::Facebook::OAuth.new(APPID, SECRET, welcome_callback_url)
    session[:access_token] = @oauth.get_access_token(params[:code]) if params[:code]
    if session[:access_token]
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Error logging in"
    end
    redirect_to welcome_index_path
  end
end
