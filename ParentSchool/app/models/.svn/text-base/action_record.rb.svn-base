class ActionRecord < ActiveRecord::Base

  #活动类型
  ACTION_TYPE = [[0, '秒杀'], [1, '抽奖'], [2, '交换'], [3, '赠予'], [4, '答卷']]
  #活动结果
  ACTION_RESULT = [[0, '秒杀失败'],[1, '秒杀成功'],[2, '抽奖失败'],[3, '抽奖成功'],[4, '申请交换失败'],[5, '申请交换成功'], [6, '交换失败'],
    [7, '交换成功'], [8, '申请赠予失败'],[9, '申请赠予成功'], [10, '赠予失败'],[11, '赠予成功'], [12, '提交答卷']]
  #活动描述
  ACTION_DESCRIBE = [[0, '秒杀'],[1, '抽奖'],[2, '申请交换'], [3, '交换'],
    [4, '申请赠予'], [5, '赠予'],[6, '提交答卷']]
    #学校类型
  SCHOOL_TYPE = [[0,'城市'],[1,'城镇'],[2,'农村']]
  #学校种类
  SCHOOL_KIND = [[1,'幼儿园'],[2,'小学'],[3,'初中'],[4,'高中']]
  #活动类型 ，结果
  MESSAGE_TYPE = [[0,'发送首次短信'],[1,'发送首次短信后未参加用户发送二次短信'],
    [2,'参加过活动未获奖但是未收到邀请他人短信'],[3,'参加过活动未获奖并且收到邀请他人短信'],[4,'参加过活动并且获奖但是未收到邀请他人短信'],[5,'参加过活动并且获奖并且收到邀请他人活动']]
  def self.action_records(action_result, first_book_code, second_book_code)
    book_name1 = "《#{Constant::All_BOOKS[first_book_code.to_i - 1][1]}》"
    book_name2 = "《#{Constant::All_BOOKS[second_book_code.to_i - 1][1]}》"
    case action_result
    when 0 then "秒杀#{book_name1}失败"
    when 1 then "秒杀#{book_name1}成功"
    when 3 then "成功获得#{book_name1}"
    when 4 then "申请用#{book_name1}换取#{book_name2}失败"
    when 5 then "申请用#{book_name1}换取#{book_name2}成功"
    when 6 then "用#{book_name1}换取#{book_name2}失败"
    when 7 then "用#{book_name1}换取#{book_name2}成功"
    when 8 then "申请赠予#{book_name1}失败"
    when 9 then "申请赠予#{book_name1}成功"
    when 10 then "赠予#{book_name1}失败"
    when 11 then "赠予#{book_name1}成功"
    else
    end
  end

  def self.create_action_record( userphone, action_type, action_result, first_book_code = nil, second_book_code = nil, spreader_phone = nil )
    ar = ActionRecord.new
    ar.user_phone = userphone
    ar.action_type = action_type
    ar.action_result = action_result
    ar.first_book_code = first_book_code
    ar.second_book_code = second_book_code
    ar.spreader_phone = spreader_phone
    ar.save
  end

  def self.user_actions(sort, action_type, cellphone)
    sort = PageRecord.sort_records(sort)
    conditions = "user_phone = '#{cellphone}'"
    unless action_type.blank?
      conditions += "and action_type = #{action_type}"
    end
    self.find(:all,:conditions => [conditions], :order => sort)
  end

  def self.to_user_actions_xls(sort, cellphone, area_name, s_type, s_group, s_name, class_name, action_type)
    Page_history.include_spread
    total_xls = self.user_actions(sort, action_type, cellphone)
    workbook = Spreadsheet::Workbook.new
    sheet = workbook.create_worksheet
    sheet.row(0).concat ["用户信息"]
    sheet.row(1).concat ["地区：", area_name, "学校类型：",
      s_type, "学校种类：", s_group, "学校名称：",
      s_name, "班级：", class_name,"手机号码", cellphone ]
    sheet.row(2).concat %w{序号 日期 活动类型 活动结果 结果描述 推荐人手机号码}
    i = 3
    s = 1
    total_xls.each { |u|
      sheet.row(i).push s, u.created_at.strftime("%Y-%m-%d %H:%M:%S"),
      ActionRecord::ACTION_TYPE[u.action_type][1], ActionRecord::ACTION_RESULT[u.action_result][1],
      ActionRecord.action_records(u.action_result, u.first_book_code, u.second_book_code),
      u.spreader_phone
      i += 1
      s += 1
    }
    excel_path  = "#{RAILS_ROOT}/public/data/reports/excel-file.xls"
    workbook.write excel_path
    excel_path
  end
end