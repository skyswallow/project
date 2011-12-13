class UserActivityRelation < ActiveRecord::Base  
  ACTIVITY_ID = 2#漂流活动id=2
  APPLY = [0, 1]#申请漂流，默认0，0：未申请，1：已申请"

  
  def self.is_apply(space_id)
    return self.find_by_activity_id_and_user_id_and_is_apply(ACTIVITY_ID, space_id, APPLY[1])
  end

  def self.do_apply(space_id)
    self.create(:activity_id => ACTIVITY_ID, :user_id => space_id, :is_apply => APPLY[1])
  end

  def self.add_point(space_id)
    uar = self.find_by_activity_id_and_user_id(ACTIVITY_ID, space_id)
    uar.point += 2
    uar.save
  end
end
