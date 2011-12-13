class Group < ActiveRecord::Base
  establish_connection :xuexi
  STATUS_NORMAL, STATUS_REQUESTED, STATUS_CLOSED = 0, 1, 2
  PERMISSION_FREEINTO, PERMISSION_CHECKINTO = 0, 1

  GROUP_STATUS     = {:NORMAL => 0, :NEW => 1, :DELETE => 2}         #  0/1/2  正常/新建等候通过/删除，外界不可见
  GROUP_PERMISSION = {:FREE_INTO => 0, :CHECK_INTO => 1}             #  0/1    自由加入/审核加入
  RECOMMEND_STATUS = {:CANCEL => 0, :RECOMMEND => 1}                 #  0/1    未被推荐/已被推荐
  GROUP_FILE_MAX_SIZE = 1024 * 1000 * 10 # 10M大小,Groups表中有一个GROUP_FILE_SIZE字段，记录群组空间使用情况

end