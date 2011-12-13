class GroupTopic < ActiveRecord::Base

  has_many :group_topic_comments, :conditions => "is_check = 1", :order => "created_at desc", :dependent => :destroy
  IS_CHECK = {:TRUE => true, :FALSE => false} #屏蔽状态 true-未屏蔽 false-已屏蔽

  def self.topics(page, per_page)
    self.paginate_by_sql(["select s.id as s_id,g.id as g_id, b.id as b_id,g.title,b.name,g.group_topic_comments_count,s.nickname,max(c.created_at) as new_time from group_topics g
              inner join topic_book_relations t on g.id = t.topic_id
              inner join books b on b.id = t.book_id
              left join group_topic_comments c on g.id = c.group_topic_id
              inner join spaces s on s.id = c.space_id where g.is_check = 1 and c.is_check = 1
              and c.created_at=(select max(c.created_at) from  group_topic_comments c)
              group by s.id ,g.id , b.id ,g.title,b.name,g.group_topic_comments_count,s.nickname
              order by max(c.created_at) desc"], :page => page, :per_page => per_page)
  end

  def self.new_topics
    self.find_by_sql("select gt.id,gt.title,gt.group_topic_comments_count from group_topics gt
               inner join topic_book_relations tbr  on gt.id = tbr.topic_id
               where gt.is_check = 1 and rownum <= 10 order by gt.created_at desc ")
  end

  def self.g_topics
    self.find_by_sql("select gt.id,gt.title,gt.group_topic_comments_count from group_topics gt
                    inner join topic_book_relations tbr  on gt.id = tbr.topic_id
                    where gt.is_check = 1 and rownum <= 10 order by gt.group_topic_comments_count desc ")
  end


  def self.get_top_topics(limit=10)
      sql_str = "select * from (select gt.* from group_topics gt
      inner join topic_book_relations tbr on tbr.topic_id=gt.id
      where gt.is_check=1
      order by gt.created_at desc) where rownum <= #{limit}"
    topics = self.find_by_sql(sql_str)
    topics
  end

  def self.get_excellent_topics(limit=10)
      self.find_by_sql(["select * from (select gt.* from group_topics gt
        inner join topic_book_relations tbr on tbr.topic_id=gt.id where  gt.is_check=1
        order by gt.group_topic_comments_count desc) where rownum <= #{limit}"])
    end

end
