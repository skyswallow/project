module Page_history

  def self.create_page_record(session_id, request, space_id)
    new_page_record2 = PageRecord.find(:first,
      :conditions => ["session_id = ? and ip = ? and url = ?", session_id, request.remote_ip, request.referer],
      :order => "created_at desc")
    new_page_record = PageRecord.new
    new_page_record.session_id = session_id
    new_page_record.ip = request.remote_ip
    new_page_record.space_id = space_id
    new_page_record.referer = request.referer ? request.referer.downcase : request.referer
    new_page_record.url = request.url.downcase
    new_page_record.save
    
    if !new_page_record2.blank?
      new_page_record2.stay_time = new_page_record.created_at - new_page_record2.created_at
      new_page_record2.save
    end
  end

  def self.include_spread
      require "spreadsheet"
  end
end