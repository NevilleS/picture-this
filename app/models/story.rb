class Story < ActiveRecord::Base
  belongs_to :user, inverse_of: :stories
  validates :title, :friend_id_1, :friend_id_2, presence: true
  validates_associated :user
  attr_accessible :body, :friend_id_1, :friend_id_2, :title
end
