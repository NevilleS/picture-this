class Story < ActiveRecord::Base
  belongs_to :user, inverse_of: :stories
  validates :title, :body, :friend_id_1, :friend_id_2, presence: true
  validates_associated :user
  attr_accessible :body, :friend_id_1, :friend_id_2, :title

  # Generate the story body from the given template and keyword hash
  def build_body(template, keywords)
    # Make a copy of the template body
    body = template.body

    # TODO: substitute user name
    # TODO: substitute friend names

    # Substitute the remaining keywords from the hash
    keywords.each do |key, value|
      body.gsub!(key, value)
    end

    # TODO: validate no keywords left
    
    # Save the built body to the story
    self.body = body
  end
end
