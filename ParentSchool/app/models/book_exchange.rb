class BookExchange < ActiveRecord::Base

  CHANGE_TYPE = {:J => 0, :Z => 1}
  
  def self.return_info book_active_info
    if book_active_info
      if book_active_info.status == 3 || book_active_info.status == 6
        return "申请获赠"
      elsif book_active_info.status == 4 || book_active_info.status == 5
        return "申请交换"
      end
    end
    return "参与操作"
  end

  def self.set_exchanges_finished(target_cellphone)
    ba = BookExchange.find_all_by_apply_user_and_is_finished(target_cellphone, 0)
    (ba || []).each do |item|
      item.is_finished = 1
      item.save    
    end
  end

  def self.current_book_exchange book_exchange
    current = Hash.new
    (book_exchange || []).each do |book|
      current.keys << book.id
      if User.find_by_target_cellphone(book.apply_user.strip)
        current[book.id] = User.find_by_target_cellphone(book.apply_user.strip).display_name
      end
    end
    return current
  end

end
