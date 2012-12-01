class Story < ActiveRecord::Base
  belongs_to :user, inverse_of: :stories
  validates_associated :user
  attr_accessible :body, :title
end
