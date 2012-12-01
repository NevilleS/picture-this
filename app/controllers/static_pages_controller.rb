class StaticPagesController < ApplicationController
  def methods
      
         # Get the user info
          @graph = Koala::Facebook::API.new(access_token)
          @access_token = access_token

  end
end
