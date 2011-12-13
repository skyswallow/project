class Space < ActiveRecord::Base
  establish_connection :xuexi

  STATUS = {:LOCK => 0, :UNLOCK => 1} #用户状态 0-锁定 1-未锁定
  IS_ACTIVE = {:FALSE => false, :TRUE => true} #激活状态 0-未激活 1-已激活
  IS_BINDING = {:FALSE => false, :TRUE =>true} #0-未绑定 1-绑定

  has_many :notices
  has_many :group_topic_comments
  has_many :articles
 
end