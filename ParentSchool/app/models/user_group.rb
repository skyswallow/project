class UserGroup < ActiveRecord::Base

  set_sequence_name :"entity_sequence"

  #群组类型
	GROUP_TYPE_USER = 0
	#教师组
  GROUP_TYPE_TEACHER = 1
	#学生组
  GROUP_TYPE_STUDENT = 2
	#好友组
  GROUP_TYPE_FRIEND = 3
	#班级
  GROUP_TYPE_SCHOOLCLASS = 4
	#年级
  GROUP_TYPE_GRADE = 5
	#学校
  GROUP_TYPE_SCHOOL = 6
  #地区
  GROUP_TYPE_REGION = 7

  GROUP_STATUS_DELETED = 40
  belongs_to :group
  has_many :group_user_relations
  has_many :users, :through => "group_user_relations"

  named_scope :normal, :conditions => "user_groups.status != 40"

end

