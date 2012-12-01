class User < ActiveRecord::Base
  has_many :stories, inverse_of: :user
  validates :email, :name, :facebook_id, presence: true
  attr_accessible :email, :name, :facebook_id
end
