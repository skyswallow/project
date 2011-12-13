class Entry < ActiveRecord::Base
  STATUS = {:NORMAL => 0, :DELETE => 1, :DRAFT => 2} #日志状态 0-正常 1-删除 2-草稿
  PERMISSION = {:PUBLIC => 0, :FRIEND => 1, :PRIVATE => 2} #日志权限 0-公开 1-好友可见 2-隐藏
  IS_RECOMMEND = {:TRUE => 1, :FALSE => 0} #推荐状态 0-未推荐 1-已推荐
  IS_LOCK = {:TRUE => true, :FALSE => false} #锁定状态 0-未锁定 1-已锁定
  IS_CHECK = {:TRUE => true, :FALSE => false} #审核状态 0-未审核 1-已审核
  IS_CHECK_VALUE = {:TRUE => 1, :FALSE => 0} #审核状态 0-未审核 1-已审核
  belongs_to :entry_category, :counter_cache => true

  def self.add_entry(space_id,entry_category_id, id, url, ip)
    entry = Entry.new
    entry.space_id = space_id
    user_nickname = Space.find_by_id(space_id).nickname
    topic_title = GroupTopic.find_by_id(id).title
    entry.title = "#{user_nickname}对#{topic_title}话题发表了评论"
    entry.content = "<a href='#{url}'>#{user_nickname}对#{topic_title}话题发表了评论</a>"
    entry.ip = ip
    entry.is_lock = Entry::IS_LOCK[:FALSE]
    entry.is_check = Entry::IS_CHECK[:TRUE]
    entry.entry_category_id = entry_category_id
    entry.save
  end

  
end
