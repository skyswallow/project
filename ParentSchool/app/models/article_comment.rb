class ArticleComment < ActiveRecord::Base

  STATUS = {:NORMAL => 1, :PASS => 0}

#  belongs_to :article, :counter_cache => true
  belongs_to :space

end