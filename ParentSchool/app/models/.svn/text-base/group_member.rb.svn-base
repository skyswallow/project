class GroupMember < ActiveRecord::Base
  establish_connection :xuexi
  STATUS_NORMAL, STATUS_REQUESTED = 0, 1

  #admin 0  member 1
  ROLE = {:TEACHER => 0, :STUDENT => 1, :PARENT => 2, :CLASS_MASTER =>3} # 群组成员角色
  STATUS = {:NORMAL => 0, :WAITING => 1} # 成员状态 0/1 正常/已加入并等管理员通过
  ROLE_ADMIN, ROLE_MEMBER = 0,1
 
end
