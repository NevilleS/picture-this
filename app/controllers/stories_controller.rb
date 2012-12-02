class StoriesController < ApplicationController
  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    @story = Story.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/new
  # GET /stories/new.json
  def new
    if !current_user? || !access_token?
      flash[:error] = "Login first"
      redirect_to welcome_index_path
    end
    @user = current_user
    @access_token = access_token
    @friends = get_friends(access_token).collect { |f| [f["name"], f["id"]] }
    @template = Template.random
    @keywords = @template.keywords_to_specify
    @story = Story.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/1/edit
  def edit
    if !current_user? || !access_token?
      flash[:error] = "Login first"
      redirect_to welcome_index_path
    end
    @user = current_user
    @access_token = access_token
    @friends = get_friends(access_token).collect { |f| [f["name"], f["id"]] }
    @story = Story.find(params[:id])
  end

  # POST /stories
  def create
    if !current_user?
      flash[:error] = "Login first"
      redirect_to welcome_index_path
    end
    @user = current_user
    @story = Story.new(params[:story])
    @story.user = current_user
    @template = Template.find(params[:template])
    @images = grab_images(@user.facebook_id, @story.friend_id_1, @story.friend_id_2)
    @story.body = @template.build_body(
      get_first_name(access_token, @user.facebook_id),
      get_first_name(access_token, @story.friend_id_1),
      get_first_name(access_token, @story.friend_id_2),
      params[:keyword], @images
    )

    if @story.save
      redirect_to @story, notice: 'Story was successfully created.'
      #@graph.put_connections("me", "notes", :subject => "a quick test post from teh graph API", :message => all_the_details)
    else
      redirect_to welcome_index_path, notice: 'Problem building story.'
    end
  end

  # PUT /stories/1
  # PUT /stories/1.json
  def update
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to stories_url }
      format.json { head :no_content }
    end
  end

  def grab_images(self_id, friend1_id, friend2_id)
    @access_token = access_token
    @story_images = Hash.new
    @story_images["<PT_IMAGE_1>"] = getFriendPhoto(self_id, @access_token, 300, 300, true)
    @story_images["<PT_IMAGE_2>"] = getFriendPhoto(friend1_id, @access_token, 300, 300, true)
    @story_images["<PT_IMAGE_3>"] = getFriendPhoto(friend2_id, @access_token, 300, 300, true)
    @story_images["<PT_IMAGE_4>"] = getFriendshipPhoto(self_id, friend1_id, @access_token, 300, 300)
    @story_images["<PT_IMAGE_5>"] = getFriendshipPhoto(friend1_id, friend2_id, @access_token, 300, 300)
    @story_images["<PT_IMAGE_6>"] = getFriendshipPhoto(self_id, friend2_id, @access_token, 300, 300)
    @story_images["<PT_IMAGE_7>"] = getThreeSomePhoto(self_id, friend1_id, friend2_id,  @access_token, 300, 300)
    @story_images
  end


  def getFriendProfilePhoto(friendId, access_token)
    @graph = Koala::Facebook::API.new(access_token)
    @access_token = access_token
    @user = @graph.get_object("me")
    @name = @user["name"]
    @photo = @graph.get_picture(friendId, :type=>"large")
    @photo
  end
 
  def getFriendPhoto(friendId, access_token, max_width, max_height, autorecover)
    access_token = access_token
    puts access_token
    graph = Koala::Facebook::API.new(access_token)
    query = "SELECT pid, src, src_big, src_big_height, src_big_width, caption FROM photo WHERE pid IN (SELECT pid FROM photo_tag WHERE subject = " + friendId.to_s + ") limit 100"

    data = graph.fql_query(query)
    rand_picture = data[rand(data.size)]

    if rand_picture.nil? and autorecover
      return_image_string = "<div class=\"error_text\">Sorry, looks like you don't have access to view <b>" + get_first_name(access_token,friendId) + "'s</b> photos. " + get_first_name(access_token,friendId) + " will have to relax his/her security settings. For now... here's a cat!</b></div><br/>
      <img src=\"http://thecatapi.com/api/images/get\?size=med\"/><br/>"
    elsif rand_picture.nil? and !autorecover
      return_image_string = nil
    else
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
    end
    return_image_string
  end


  def getFriendshipPhoto(friendId1, friendId2, access_token, max_width, max_height)
    
    @graph = Koala::Facebook::API.new(access_token)
    @access_token = access_token
    query = "SELECT pid, src_big, src_big_height, src_big_width, caption FROM photo WHERE pid IN (SELECT pid FROM photo_tag WHERE subject = "+friendId1.to_s+") AND pid IN (SELECT pid FROM photo_tag WHERE subject = "+friendId2.to_s+")"
    
    @data = @graph.fql_query(query)
    @rand_picture = @data[rand(@data.size)]
    if @rand_picture.nil?
      return_image_string = getFriendPhoto(friendId2,access_token,max_width,max_height, false)
      if return_image_string.nil?
        return_image_string = getFriendPhoto(friendId1,access_token,max_width,max_height, true)
      end
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


  def getThreeSomePhoto(friendId1, friendId2, friendId3, access_token, max_width, max_height)
    
    @graph = Koala::Facebook::API.new(access_token)
    @access_token = access_token

   query = "SELECT pid, src_big, src_big_height, src_big_width, caption FROM photo WHERE pid IN (SELECT pid FROM photo_tag WHERE subject = "+friendId1.to_s+") AND pid IN (SELECT pid FROM photo_tag WHERE subject = "+friendId2.to_s+") AND pid IN (SELECT pid FROM photo_tag WHERE subject = "+friendId3.to_s+")"

    @data = @graph.fql_query(query)
    @rand_picture = @data[rand(@data.size)]
    if @rand_picture.nil?
      return_image_string = getFriendshipPhoto(friendId1, friendId2, access_token, max_width, max_height)
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

      return_image_string = "<img src=\"" + @rand_picture["src_big"] + "\" width=\""+newWidth.to_s+"\" height=\""+newHeight.to_s+"\" />"
    end
    return_image_string
  end
end
