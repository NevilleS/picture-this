module WelcomeHelper

  def getFriendPic(friendId, access_token)
    @graph = Koala::Facebook::API.new(access_token)
    @access_token = access_token
    @photo = @graph.get_picture(friendId)
    @photo
  end

end
