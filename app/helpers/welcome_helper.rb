module WelcomeHelper

  def getFriendPic(friendId, access_token)
    @graph = Koala::Facebook::API.new(access_token)
    @access_token = access_token
<<<<<<< HEAD
    @user = @graph.get_object("me")
    @name = @user["name"]
    @photo = @graph.get_picture(friendId, :type=>"large")
    puts "hello"
    puts @photo
=======
    @photo = @graph.get_picture(friendId)
>>>>>>> fa365112a542b87a5d3c436e7bc78367c3c2cbf7
    @photo
  end

end
