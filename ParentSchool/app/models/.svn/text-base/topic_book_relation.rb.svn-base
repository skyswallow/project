class TopicBookRelation < ActiveRecord::Base

  belongs_to :book
  
  def self.get_top_topics_with_space(space_id,limit=3)
    sql_str = "select * from (select gt.id,gt.title from group_topics gt inner join group_topic_comments gtc
      on gtc.group_topic_id=gt.id and gt.space_id='#{space_id}'
      inner join topic_book_relations tbr on tbr.topic_id=gt.id
      where gt.is_check=1 and gtc.is_check=1
      order by gtc.created_at desc) where rownum <= #{limit}"
    topics = self.find_by_sql(sql_str)
    topics
  end

  def self.get_top_topics(limit=10)
    sql_str = "select * from (select gt.* from group_topics gt
      inner join topic_book_relations tbr on tbr.topic_id=gt.id
      where gt.is_check=1
      order by gt.created_at desc) where rownum <= #{limit}"
    topics = self.find_by_sql(sql_str)
    topics
  end
  
end
