class ActivityApply < ActiveRecord::Base

  named_scope :all_by_activity_id, lambda { |activity_id| { :conditions => ['activity_id = ?', activity_id]}}
  named_scope :order_by_created_at_desc, :order => "created_at desc"

  belongs_to :activity, :counter_cache => true

end
