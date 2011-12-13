class BookListing < ActiveRecord::Base

   belongs_to :book

  def BookListing.find_grade_type_books(grade_type)
    return Book.find(:all,
                     :select => "bl.id blist_id, b.*",
                     :conditions => "bl.grade_type=#{grade_type}",
                     :joins => " b inner join book_listings bl on bl.book_id = b.id")
  end

  def BookListing.find_book_detail(blist_id)
    return BookListing.find(:first,
            :select => "bl.grade_type, b.*",
            :conditions => ["bl.id = ?", blist_id],
            :joins => "bl inner join books b on bl.book_id = b.id")
  end

  def BookListing.find_top_articles(blist_id, page)
    return Article.paginate(:select => "s.nickname, a.*",
                 :conditions => ["a.status = 1 and ba.book_listing_id = ?", blist_id],
                 :joins => "a inner join book_articles ba on a.id = ba.article_id
                            inner join spaces s on a.space_id = s.id",
                 :order => "a.updated_at desc",
                 :page => page, :per_page => 3)
  end

  def BookListing.find_top_group_topics(blist_id, page)
    sql = "select s.id as space_id, gt.id as gt_id, gt.title, gt.group_topic_comments_count, s.nickname, max(gtc.created_at) as new_time from group_topics gt
              inner join topic_book_relations tbr on gt.id = tbr.topic_id
              inner join book_listings bl on tbr.book_id = bl.book_id
              left join group_topic_comments gtc on gt.id = gtc.group_topic_id
              inner join spaces s on s.id = gtc.space_id where gt.is_check = 1 and gtc.is_check = 1
              and gtc.created_at=(select max(gtc.created_at) from  group_topic_comments gtc) and bl.id = ?
              group by s.id, gt.id, gt.title, gt.group_topic_comments_count, s.nickname
              order by max(gtc.created_at) desc"
    return GroupTopic.paginate_by_sql([sql, blist_id],:page => page, :per_page => 3)
  end

end
