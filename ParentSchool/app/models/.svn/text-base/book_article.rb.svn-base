class BookArticle < ActiveRecord::Base

  def self.get_top_articles(space_id,limit=3)
    sql_str = "select * from (select a.id,a.title from articles a
      inner join book_articles ba on ba.article_id=a.id
      where a.status = #{Article::STATUS[:PASS]} and a.space_id='#{space_id}'
      order by a.created_at desc) where rownum <= #{limit}"
    articles = self.find_by_sql(sql_str)
    articles
  end
end
