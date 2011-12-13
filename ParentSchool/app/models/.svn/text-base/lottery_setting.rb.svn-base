class LotterySetting < ActiveRecord::Base


  def mk_lottery(ba, is_survey)
    flag = false
    lr = LotteryRecord.create(:user_id => ba.user_id, :is_award => LotteryRecord::IS_AWARD[:F])
    arr = []
    arr << 1 if self.s_count > self.s_real_count.to_i
    arr << 2 if self.b_count > self.b_real_count.to_i
    arr << 3 if self.e_count > self.e_real_count.to_i
    x = arr[rand(arr.length)]
    if x
      if lr.id.modulo(self.pv_count/(self.s_count + self.b_count + self.e_count)) == 0
        flag = true
        if is_survey.to_i == 0 or ba.status == BookActivity::STATUS[:ASK] or ba.status == BookActivity::STATUS[:FAIL_BUT_ASK]
          ba.update_attributes(:book_code => x, :status => BookActivity::STATUS[:LOTTERY],
            :real_count => ba.real_count.to_i - 1)
          self.update_attribute(:s_real_count, self.s_real_count.to_i + 1) if x == 1
          self.update_attribute(:b_real_count, self.b_real_count.to_i + 1) if x == 2
          self.update_attribute(:e_real_count, self.e_real_count.to_i + 1) if x == 3
        end
        lr.update_attribute(:is_award, LotteryRecord::IS_AWARD[:T])
      end
    end
    flag
  end

end
