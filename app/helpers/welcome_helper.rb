module WelcomeHelper

  def getFriendProfilePhoto(friendId, access_token)
    @graph = Koala::Facebook::API.new(access_token)
    @access_token = access_token
    @user = @graph.get_object("me")
    @name = @user["name"]
    @photo = @graph.get_picture(friendId, :type=>"large")
    @photo
  end
 
  def getFriendPhoto(friendId, access_token, max_width, max_height)
    graph = Koala::Facebook::API.new(access_token)
    access_token = access_token
    query = "SELECT pid, src, src_big, src_big_height, src_big_width, caption FROM photo WHERE pid IN (SELECT pid FROM photo_tag WHERE subject = " + friendId.to_s + ") limit 100"
    puts query

    data = graph.fql_query(query)
    rand_picture = data[rand(data.size)]
    puts data.size

    # Scale the image 
    height = rand_picture["src_big_height"]
    width = rand_picture["src_big_width"]

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

    puts rand_picture["src_big"]

    return_image_string = "<img src=\"" + rand_picture["src_big"] + "\" width=\""+newWidth.to_s+"\" height=\""+newHeight.to_s+"\" />"
    return_image_string
  end


  def getFriendshipPhoto(friendId1, friendId2, access_token, max_width, max_height, autofallback)
    
    @graph = Koala::Facebook::API.new(access_token)
    @access_token = access_token
    query = "SELECT pid, src_big, src_big_height, src_big_width, caption FROM photo WHERE pid IN (SELECT pid FROM photo_tag WHERE subject = "+friendId1.to_s+") AND pid IN (SELECT pid FROM photo_tag WHERE subject = "+friendId2.to_s+")"
    
    @data = @graph.fql_query(query)
    @rand_picture = @data[rand(@data.size)]
    if @rand_picture.nil? and autofallback
      return_image_string = getFriendPhoto(friendId2,access_token,max_width,max_height)
    else
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
    end
    return_image_string
  end

end
