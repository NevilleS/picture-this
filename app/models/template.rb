class Template < ActiveRecord::Base
  PT_KEYWORD = /<PT_.*?>/
  PT_KEYWORD_KEY = /<PT_([A-Za-z() ]+)/
  PT_USER_KEYWORD = "<PT_USER>"
  PT_FRIEND_1_KEYWORD = "<PT_FRIEND_1>"
  PT_FRIEND_2_KEYWORD = "<PT_FRIEND_2>"

  attr_accessible :body, :title

  # Return a random template from the database
  def self.random
    count = Template.count
    if count > 0
      return Template.all[rand(count)]
    end
    return nil
  end

  # Get a hash of all keywords used in the template, sorted by type:
  # {
  #   "USER" => ["PT_USER"],
  #   "FRIEND" => ["PT_FRIEND_1"],
  #   "VERB" => ["PT_VERB_1", "PT_VERB_2"],
  #   "NOUN" => ["PT_NOUN_1", "PT_NOUN_2"]
  # }
  def keywords_by_type
    words = self.body.scan(PT_KEYWORD).uniq
    return words.inject({}) do |keywords, word|
      match = word.match(PT_KEYWORD_KEY)
      if match and match.size == 2
        key = match[1]
        keywords[key] ||= []
        keywords[key] << word
      end
      keywords
    end
  end

  # Get a hash of the keywords to specify for this template, which filters out the "USER", "FRIEND", and IMAGE types
  def keywords_to_specify
    keywords = keywords_by_type
    return keywords.select { |key| !["USER", "FRIEND", "IMAGE"].include?(key) }
  end

  # Generate a story body from the given template and keyword hash
  def build_body(user, friend_1, friend_2, keywords, images)
    # Make a copy of the template body
    body = self.body

    # Substitute user name
    body.gsub!(PT_USER_KEYWORD, user)

    # Substitute friend names
    body.gsub!(PT_FRIEND_1_KEYWORD, friend_1)
    body.gsub!(PT_FRIEND_2_KEYWORD, friend_2)

    # Substitute the remaining keywords from the hash
    keywords.each do |key, value|
      value = value.pluralize if key =~ /PLURAL/
      body.gsub!(key, value)
    end

    # Substitute the image keywords from the hash
    images.each do |key, value|
      body.gsub!(key, value)
    end

    # TODO: validate no keywords left
    return body
  end
end
