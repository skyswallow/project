class BookActivity < ActiveRecord::Base

  #0:邀请，1：申领成功，2：申领失败，3：填写了问卷，4： 抽奖成功，5： 申领成功并且填写了问卷，6： 申领失败但是填写了问卷,7:图书已送出
  STATUS = {:INVITE => 0, :SUCCESS => 1, :FAIL => 2, :ASK => 3, 
    :LOTTERY => 4, :SUCCESS_AND_ASK => 5, :FAIL_BUT_ASK => 6}

  PARENTTYPE = {:F => true, :T => false} #false:是小学生家长，true:其他

#  named_scope :normal, :conditions => "status != #{STATUS[:OVER]}"
  
  def self.apply(username, book_id)
    str = ""
    span_str = ""
    type = 0
    @ba = nil
    if 19 <= Time.now.strftime("%H").to_i and  Time.now.strftime("%H").to_i < 21
      if username
        if book_id
          @ba = BookActivity.first(:conditions => ["target_cellphone = ? ", username.strip])
          BookActivity.transaction do
            BookSetting.transaction do
              BookExchange.transaction do
                if @ba
                  if @ba.active_date.strftime("%Y%m%d").to_i == Time.now.strftime("%Y%m%d").to_i
                    bs = BookSetting.find_all_by_book_code(book_id.to_i, :conditions => "created_at=to_date('#{Time.now.to_date.to_s}','yyyy-mm-dd')", :order => "created_at desc")[0]
                    up_time = bs.updated_at
                    if bs.total_count.to_i > bs.real_count.to_i
                      if @ba.status == BookActivity::STATUS[:INVITE] or @ba.status == BookActivity::STATUS[:FAIL]
                        type = 2
                        bb = BookSetting.find_by_id(bs.id)
                        if up_time == bb.updated_at
                          @ba.update_attributes(:status => BookActivity::STATUS[:SUCCESS], :book_code => book_id.to_i)
                          bb.update_attribute(:real_count, bb.real_count.to_i + 1)
                          (BookExchange.find_all_by_apply_user_and_is_finished_and_exchange_type(@ba.target_cellphone,0,1) || []).each do |be|
                            be.update_attribute(:is_finished, 1)
                          end
                          str = "恭喜！您已成功申领图书《#{Constant::All_BOOKS[book_id.to_i - 1][1]}》，图书将在整个活动结束后，由您孩子所在学校送达。"
                        else
                          @ba.update_attribute(:status, BookActivity::STATUS[:FAIL])
                          str = "抱歉您的图书申领失败。"
                        end
                        span_str = "为提高南通市网上家长学校的服务质量，现邀请您填写一份关于您孩子学习的调查问卷，页面将自动跳转。"
                      elsif @ba.status == BookActivity::STATUS[:ASK] or @ba.status == BookActivity::STATUS[:FAIL_BUT_ASK]
                        bb = BookSetting.find_by_id(bs.id)
                        if up_time == bb.updated_at
                          @ba.update_attributes(:status => BookActivity::STATUS[:SUCCESS_AND_ASK], :book_code => book_id.to_i)
                          bb.update_attribute(:real_count, bb.real_count.to_i + 1)
                          str = "恭喜！您已成功申领图书《#{Constant::All_BOOKS[book_id.to_i - 1][1]}》，图书将在整个活动结束后，由您孩子所在学校送达。"
                          (BookExchange.find_all_by_apply_user_and_is_finished_and_exchange_type(@ba.target_cellphone,0,1) || []).each do |be|
                            be.update_attribute(:is_finished, 1)
                          end
                        else
                          @ba.update_attribute(:status, BookActivity::STATUS[:FAIL_BUT_ASK])
                          str = "抱歉您的图书申领失败。"
                        end
                      elsif @ba.status == BookActivity::STATUS[:SUCCESS]
                        type = 2
                        str = "您已经成功申领过图书。因图书数量有限，您不能再次申领。谢谢！"
                        span_str = "为提高南通市网上家长学校的服务质量，现邀请您填写一份关于您孩子学习的调查问卷，页面将自动跳转。"
                      elsif @ba.status == BookActivity::STATUS[:LOTTERY]
                        str = "您已成功获赠图书。因图书数量有限，您不能再次申领。谢谢！"
                      elsif @ba.status == BookActivity::STATUS[:SUCCESS_AND_ASK]
                        str = "您已成功申领图书。因图书数量有限，您不能再次申领。谢谢！"
                      end
                    else
                      if @ba.status == BookActivity::STATUS[:INVITE]
                        @ba.update_attribute(:status, BookActivity::STATUS[:FAIL])
                        type = 1
                        str = "抱歉您的图书申领失败。"
                        span_str = "南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。"
                      elsif @ba.status == BookActivity::STATUS[:FAIL] or @ba.status == BookActivity::STATUS[:FAIL_BUT_ASK]
                        type = 1
                        str = "抱歉您的图书申领失败。"
                        span_str = "南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。"
                      elsif @ba.status == BookActivity::STATUS[:ASK]
                        @ba.update_attribute(:status, BookActivity::STATUS[:FAIL_BUT_ASK])
                        type = 1
                        str = "抱歉您的图书申领失败。"
                        span_str = "南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。"
                      elsif @ba.status == BookActivity::STATUS[:SUCCESS]
                        type = 2
                        str = "您已经成功申领过图书。因图书数量有限，您不能再次申领。谢谢！"
                        span_str = "为提高南通市网上家长学校的服务质量，现邀请您填写一份关于您孩子学习的调查问卷，页面将自动跳转。"
                      elsif @ba.status == BookActivity::STATUS[:LOTTERY]
                        str = "您已成功获赠图书。因图书数量有限，您不能再次申领。谢谢！"
                      elsif @ba.status == BookActivity::STATUS[:SUCCESS_AND_ASK]
                        str = "您已成功申领图书。因图书数量有限，您不能再次申领。谢谢！"
                      end
                    end
                  else
                    if @ba.status == BookActivity::STATUS[:INVITE]
                      type = 1
                      str = "因赠书采取分批申领，您暂不能参与此批图书申领，请您根据短信内容中提供的申领日期进行申领。谢谢！"
                      span_str = "南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。"
                    elsif @ba.status == BookActivity::STATUS[:FAIL] or @ba.status == BookActivity::STATUS[:FAIL_BUT_ASK]
                      type = 1
                      str = "抱歉您的图书申领失败。"
                      span_str = "南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。"
                    elsif @ba.status == BookActivity::STATUS[:ASK]
                      type = 1
                      @ba.status = BookActivity::STATUS[:FAIL_BUT_ASK]
                      str = "抱歉您的图书申领失败。"
                      span_str = "南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。"
                    elsif @ba.status == BookActivity::STATUS[:SUCCESS]
                      type = 2
                      str = "您已经成功申领过图书。因图书数量有限，您不能再次申领。谢谢！"
                      span_str = "为提高南通市网上家长学校的服务质量，现邀请您填写一份关于您孩子学习的调查问卷，页面将自动跳转。"
                    elsif @ba.status == BookActivity::STATUS[:LOTTERY]
                      str = "您已成功获赠图书。因图书数量有限，您不能再次申领。谢谢！"
                    elsif @ba.status == BookActivity::STATUS[:SUCCESS_AND_ASK]
                      str = "您已成功申领图书。因图书数量有限，您不能再次申领。谢谢！"
                    end
                  end
                else
                  type = 2
                  str = "抱歉您的图书申领失败。"
                  span_str = "南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。"
                end
              end
            end
          end
        else
          str = "请您选择一本要申领的图书，谢谢！"
        end
      else
        str = "请输入您的网上家长学校的账号，谢谢！"
      end
    elsif 19 > Time.now.strftime("%H").to_i
      str = "抱歉，申领尚未开始！"
    elsif 21 <= Time.now.strftime("%H").to_i
      str = "抱歉，申领已经结束！"
    end
    #    p type.to_s + ":" + @ba.status.to_s + ":" + str + ":" + span_str
    return @ba.nil?? type.to_s + "::" + str + ":" + span_str + ":" : type.to_s + ":" + @ba.status.to_s + ":" + str + ":" + span_str + ":" + @ba.target_cellphone
  end

  def self.award_list
    award_list1 = []
    dd = Time.mktime(2010, 11, 01).to_date
    i = 0
    num = Date.today - dd
    while(num >= i)
      if dd.wday.to_i == 1
        award_list1  << dd
      end
      if dd.wday.to_i == 0
        award_list1  << dd
      end
      dd += 1
      i += 1
    end
    award_list1 << Date.today
    award_list2 = []
    0.upto(award_list1.length/2-1) do |y|
      award_list2 << [award_list1[2*y], award_list1[2*y + 1]]
    end
    return award_list2.reverse
  end
end
