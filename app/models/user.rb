class User < ActiveRecord::Base
  has_many :stories, inverse_of: :user
  attr_accessible :email, :name
end
