class Message < ActiveRecord::Base

  STATUS = {:UNREAD => 0, :READ => 1, :DELETE => 2, :DRAFT => 3} #站内信状态 0-未读 1-已读 2-收件箱删除 3-草稿

  named_scope :unread, lambda { |space_id| { :conditions => ['receiver_id = ? and status = ?', space_id, STATUS[:UNREAD]]}}

end
