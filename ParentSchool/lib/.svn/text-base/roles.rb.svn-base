# To change this template, choose Tools | Templates
# and open the template in the editor.

module Roles

  def current_space_session
    is_current_space_flag = true
    if session[:net_class_role] == nil
      is_current_space_flag = false
    else
      current_space_id = session[:net_class_role].split("_")[0]
      if current_space_id.to_s != cookies[:space_id]
        is_current_space_flag = false
      end
    end
    if is_current_space_flag == false
      net_class_role(cookies[:space_id])
    end
  end

  #当前登录人在网班是管理员
  def is_net_class_manager?
    current_space_session
    session[:net_class_role] == cookies[:space_id] + "_" + Constant::CLASS_MANAGERR
  end

  #当前登录人在网班是班主任
  def is_net_class_master?
    current_space_session
    session[:net_class_role] == cookies[:space_id] + "_" + Constant::CLASS_MASTER
  end

  #当前登录人在网班是老师
  def is_net_class_teacher?
    current_space_session
    session[:net_class_role] == cookies[:space_id] + "_" + Constant::CLASS_TEACHER
  end

  #当前登录人在网班是学生
  def is_net_class_student?
    current_space_session
    session[:net_class_role] == cookies[:space_id] + "_" + Constant::CLASS_STUDENT
  end

  #当前登录人在网班是家长
  def is_net_class_parent?
    current_space_session
    session[:net_class_role] == cookies[:space_id] + "_" + Constant::CLASS_PARENT
  end

  #当前登录人在网班是普通人
  def is_net_class_normal?
    current_space_session
    session[:net_class_role] == cookies[:space_id] + "_" + Constant::CLASS_NORMAL
  end

  def is_net_class_teacher_member?
    current_space_session
    is_net_class_member_flag = false
    if is_net_class_manager? or is_net_class_master? or is_net_class_teacher?
      is_net_class_member_flag = true
    end
    return is_net_class_member_flag
  end

  #判断当前登录的人在网班的角色
  def net_class_role(space_id)
    if space_id
      group = Group.first(
        :conditions => ["initiator_id = ? and status = ? and user_group_id is not null ", space_id, Group::GROUP_STATUS[:NORMAL]])
      if group
        session[:net_class_role] = space_id + "_" + Constant::CLASS_MANAGERR
      else
        group_member_roles = GroupMember.find(:all,
          :conditions => ["space_id = ? and status = ?", space_id, GroupMember::STATUS[:NORMAL]])
        if group_member_roles and !group_member_roles.blank?
          roles = []
          roles = group_member_roles.collect { |item| item.role }
          if roles.include?(GroupMember::ROLE[:CLASS_MASTER])
            session[:net_class_role] = space_id + "_" + Constant::CLASS_MASTER
          elsif roles.include?(GroupMember::ROLE[:TEACHER])
            session[:net_class_role] = space_id + "_" + Constant::CLASS_TEACHER
          elsif roles.include?(GroupMember::ROLE[:PARENT])
            session[:net_class_role] = space_id + "_" + Constant::CLASS_PARENT
          elsif roles.include?(GroupMember::ROLE[:STUDENT])
            session[:net_class_role] = space_id + "_" + Constant::CLASS_STUDENT
          else
            session[:net_class_role] = space_id + "_" + Constant::CLASS_NORMAL
          end
        else
          session[:net_class_role] = nil
        end
      end
    else
      session[:net_class_role] = nil
    end
  end

  #是否收费用户
  def is_charge_user?
    is_current_space_flag = true
    if session[:is_charge] == nil
      is_current_space_flag = false
    else
      current_space_id = session[:is_charge].split("_")[0]
      if current_space_id.to_s != cookies[:space_id]
        is_current_space_flag = false
      end
    end
    if is_current_space_flag == false
      charge_user
    end
    if cookies[:space_id] and session[:is_charge] == cookies[:space_id] + "_true"
      return true
    else
      return false
    end
  end

  def charge_user
    is_charge_flag = false
    if cookies[:space_id]
      users = User.find(:all, :select => "users.*", :joins => "left join spaces s on s.user_id = users.person_id ",
        :conditions => ["s.id = ? and users.status != ? and (users.user_type = ? or users.user_type = ?) ",
          cookies[:space_id], User::USER_STATUS_DELETED, User::USER_TYPE_STUDENT, User::USER_TYPE_PARENT])
      if users and !users.blank?
        for user in users
          if user.user_type == User::USER_TYPE_PARENT
            if user.status == User::USER_STATUS_CHARGE or user.status == User::USER_STATUS_SPECIAL_FREE or user.status == User::USER_STATUS_ACTIVITY or user.status == User::USER_STATUS_CHARGE_APPLICATION
              is_charge_flag = true
            end
          else
            parents = User.find_by_sql(["select u.* from parents p left join users u on u.id = p.id where p.student_id = ? and u.status != ?",
                user.id, User::USER_STATUS_DELETED])
            if parents and !parents.blank?
              for parent in parents
                if parent.status == User::USER_STATUS_CHARGE or parent.status == User::USER_STATUS_SPECIAL_FREE or parent.status == User::USER_STATUS_ACTIVITY or user.status == User::USER_STATUS_CHARGE_APPLICATION
                  is_charge_flag = true
                  break
                end
              end
            end
          end
        end
      end
      session[:is_charge] = cookies[:space_id] + "_" + is_charge_flag.to_s
    else
      session[:is_charge] = "null" + "_" + is_charge_flag.to_s
    end

  end

end
