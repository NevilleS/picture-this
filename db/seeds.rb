# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Template.delete_all
Template.create(
  title: "Epic Road Trip",
  body:
  %{
    
    <br/><br/><br/>
    <div class="titlestory"> Picture this...</div><br/><br/>
    <div class="storyfont">
      <div class="imagecenter"><PT_IMAGE_4_1></div><br /><br/>
    <div class="storyline1"> <div class="storyplotDiv">
      <PT_USER> and <PT_FRIEND_1> were packing up their <PT_VEHICLE_1> for their road trip to <PT_PLACE_1>.<br />
    </div></div>
      <br/><br/>
      <div class="imagecenter"><PT_IMAGE_2_1></div>
      <br /><br/>
    <div class="storyline2"> <div class="storyplotDiv">
      When all of a sudden, <PT_FRIEND_1> saw <PT_NUMBER_1> <PT_NOUN_PLURAL_1> fall from <PT_LOCATION_1>!<br />
    </div></div>
      <br/><br/>
      <div class="imagecenter"><PT_IMAGE_4_2> </div> 
      <br /><br/>
    <div class="storyline3"> <div class="storyplotDiv">
      <PT_USER> and <PT_FRIEND_1> grabbed the nearest <PT_NOUN_PLURAL_2> and ran for shelter.<br />
    </div></div>
      <br/><br/>
      <div class="imagecenter"><PT_IMAGE_3_1></div>
      <br /><br/>
    <div class="storyline4"> <div class="storyplotDiv">
      It looked like their road trip might not happen :( <br/> 
      Just as they were about to give up, <PT_FRIEND_2> showed up with <PT_NOUN_PLURAL_3> and saved the day!<br />
    </div></div>
      <br/><br/>
      <div class="imagecenter"><PT_IMAGE_7_1></div>
      <br /><br/>
    <div class="storyline5"> <div class="storyplotDiv">
      The three of them made it to <PT_PLACE_1> after all.<br/>
      MORAL OF THE STORY: <br/>
      always remember to invite <PT_FRIEND_2> on trips, or pack your own <PT_NOUN_PLURAL_3>!<br />
    </div></div>
    <br/><br/>

    </div>
  }
)
