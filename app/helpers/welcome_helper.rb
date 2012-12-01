module WelcomeHelper

  def getFriendPic(friendId, access_token)
    puts "into the getFriendPic helper"
    @graph = Koala::Facebook::API.new(access_token)
    @access_token = access_token
    @user = @graph.get_object("me")
    @name = @user["name"]
    @photo = @graph.get_picture(friendId, :type=>"large")
    puts "hello"
    puts @photo
    @photo
  end

end
