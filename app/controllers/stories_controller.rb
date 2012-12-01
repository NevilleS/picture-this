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
    @story.body = @template.build_body(
      get_first_name(access_token, @user.facebook_id),
      get_first_name(access_token, @story.friend_id_1),
      get_first_name(access_token, @story.friend_id_2),
      params[:keyword]
    )

    if @story.save
      redirect_to @story, notice: 'Story was successfully created.'
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
end
