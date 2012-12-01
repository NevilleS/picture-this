class Template < ActiveRecord::Base
  attr_accessible :body, :title

  # Get a hash of all keywords used in the template, sorted by type:
  # {
  #   "USER" => ["PT_USER"],
  #   "FRIEND" => ["PT_FRIEND_1"],
  #   "VERB" => ["PT_VERB_1", "PT_VERB_2"],
  #   "NOUN" => ["PT_NOUN_1", "PT_NOUN_2"]
  # }
  def keywords_by_type
    words = @template.body.scan(PT_KEYWORD)
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

  # Get a hash of the keywords to specify for this template, which filters out the "USER" and "FRIEND" types
  def keywords_to_specify
    keywords = keywords_by_type
    return keywords.select { |key| !["USER", "FRIEND"].include?(key) }
  end
end
