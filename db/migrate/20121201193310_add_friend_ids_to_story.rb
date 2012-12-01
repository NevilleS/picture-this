class AddFriendIdsToStory < ActiveRecord::Migration
  def change
    add_column :stories, :friend_id_1, :integer
    add_column :stories, :friend_id_2, :integer
  end
end
