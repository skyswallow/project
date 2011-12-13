class Article < ActiveRecord::Base

  has_many :article_comments
  belongs_to :space
  
  STATUS = {:NORMAL => 0, :PASS => 1, :REFUSE => 2}
  named_scope :pass, :conditions => "status = #{STATUS[:PASS]}"

  def self.get_newest_articles(limit = 10)
      self.all(:conditions => ["status = ?", STATUS[:PASS]], :include => :space, :order => "articles.created_at desc",
        :joins => "inner join book_articles ba on ba.article_id=articles.id", :limit => limit)
    end

  def self.get_excellent_articles
      self.find_by_sql(["select t.space_id,t.id,t.nickname,t.title,t.total_score from (
                           select ROW_NUMBER() over(partition by a.space_id order by a.total_score desc) rk,s.id space_id,a.id,a.title,a.total_score,a.status,s.nickname from articles a
                           inner join book_articles ba on ba.article_id=a.id
                           inner join spaces s on a.space_id=s.id where a.status='1') t where t.rk=1 and t.status=? order by t.total_score desc", STATUS[:PASS]])[0, 10]
    end
end