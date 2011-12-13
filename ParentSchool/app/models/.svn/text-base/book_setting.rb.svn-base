class BookSetting < ActiveRecord::Base

  def self.has_books date
    today_books = self.find(:all, :limit => 3, :order => "book_code asc",
      :conditions => "created_at = to_date('#{date.to_date}','yyyy-mm-dd hh24:mi:ss')")
    has_book = [true,true,true,true]
    unless today_books.blank?
      arr = [0,0]
      i = 0
      today_books.each do |b|
        arr[0] += b.total_count.to_i
        arr[1] += b.real_count.to_i
        has_book[i] = false if b.total_count.to_i == b.real_count.to_i
        i += 1
      end
      has_book[i] = false if arr[0] == arr[1]
    else
      has_book = [true,true,true,false]
    end
    return has_book
  end
end
