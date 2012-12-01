module WelcomeHelper

  def getFriendPic(friendId, access_token)
    @graph = Koala::Facebook::API.new(access_token)
    @access_token = access_token
    @user = @graph.get_object("me")
    @name = @user["name"]
    @photo = @graph.get_picture(friendId, :type=>"large")
    @photo
  end

  def getFriendshipPhoto (friendId1, friendId2, access_token, max_height, max_width)
    
    @graph = Koala::Facebook::API.new(access_token)
    @access_token = access_token
    query = "SELECT pid, src_big, src_big_height, src_big_width, caption FROM photo WHERE pid IN (SELECT pid FROM photo_tag WHERE subject = 122604676) AND pid IN (SELECT pid FROM photo_tag WHERE subject = 122603619)"
    
    @data = @graph.fql_query(query)
    @rand_picture = @data[rand(@data.size)]

    # Scale the image 
    height = @rand_picture["src_big_height"]
    width = @rand_picture["src_big_width"]

    heightFactor = max_height * 1.0 / height
    widthFactor = max_width * 1.0 / width

    if heightFactor > widthFactor
      puts widthFactor
      factor = widthFactor
    else
      puts heightFactor
      factor = heightFactor
    end

    newWidth = width * factor
    newHeight = height * factor

    puts @rand_picture["src_big"]

    return_image_string = "<img src=\"" + @rand_picture["src_big"] + "\" width=\""+newWidth.to_s+"\" height=\""+newHeight.to_s+"\" />"
    return_image_string
  end

end
