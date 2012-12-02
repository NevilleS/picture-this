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
    <p>
    <br/><br/><br/><br/><br/><br/>
    Picture this...<br/><br/><br/><br/><br/><br/>

    <PT_IMAGE_1><br /><br/><br/><br/>
    <PT_USER> and <PT_FRIEND_1> were packing up their <PT_VEHICLE_1> for their road trip to <PT_PLACE_1>.<br />
    <br/><br/><br/><br/><br/><br/>

    <PT_IMAGE_2><br /><br/><br/><br/>
    When all of a sudden <PT_NUMBER_1> <PT_OBJECTS_1> fell from <PT_LOCATION_1>!<br />
    <br/><br/><br/><br/><br/><br/>

    <PT_IMAGE_4><br /><br/><br/><br/>
    <PT_USER> and <PT_FRIEND_1> grabbed the nearest <PT_OBJECTS_2> and ran for shelter.<br />
    <br/><br/><br/><br/><br/><br/>

    <PT_IMAGE_3><br /><br/><br/><br/>
    It looked like their road trip might not happen. Just as they were about to give up, <PT_FRIEND_2> showed up with <PT_OBJECTS_3> and saved the day!<br />
    <br/><br/><br/><br/><br/><br/>

    <PT_IMAGE_7><br /><br/><br/><br/>
    Morale of the story: always remember to invite <PT_FRIEND_2> on trips, or pack your own <PT_OBJECTS_3>.<br />
    <br/><br/><br/><br/><br/><br/>

    </p>
  }
)
