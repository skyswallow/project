class GroupTopicComment < ActiveRecord::Base

  belongs_to :group_topic, :counter_cache => true
  belongs_to :space
  IS_CHECK = {:TRUE => true, :FALSE => false} #屏蔽状态 true-未屏蔽 false-已屏蔽

  def self.add_comment(content, space_id, group_topic_id, is_check, ip)
    self.create(:content => content, :space_id => space_id, :group_topic_id => group_topic_id, :is_check => is_check, :ip => ip)
  end

  named_scope :normal, :conditions => "is_check = 1"

end
