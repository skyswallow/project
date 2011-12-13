class WaitingMessage < ActiveRecord::Base
  set_sequence_name :"message_sequence"
  belongs_to :waiting_messsage_record

  #短信长度
  #手机
  MOBILE_LENGTH = 70
	#小灵通
	PHONE_LENGTH = 40

  def self.send_exam_message(waiting_record,target_user,content,service_code)
    waiting_message = WaitingMessage.new
    waiting_message.send_record_id = waiting_record.id
    waiting_message.content = content
    waiting_message.target_user_id = target_user.id
    waiting_message.source_user_id = waiting_record.send_user_id
    waiting_message.service_code = service_code
    waiting_message.save
  end

  def self.generate_send_message(waiting_record,target_user,content,service_code)
    waiting_message = WaitingMessage.new
    waiting_message.send_record_id = waiting_record.id
    if content.include?('%name%')
      if waiting_record.message_type  == WaitingMessageRecord::MESSAGE_TYPE_STUDENT and target_user.user_type == User::USER_TYPE_PARENT
        realcontent = content.gsub(/%name%/, target_user.student.user.display_name)
      else
        realcontent = content.gsub(/%name%/, target_user.display_name)
      end
      waiting_message.content = realcontent.to_s
    else
      waiting_message.content = content.to_s
    end
    waiting_message.target_user_id = target_user.id
    waiting_message.source_user_id = waiting_record.send_user_id
    waiting_message.service_code = service_code
    waiting_message.save
  end

  def self.generate_waiting_message(content_list,waiting_record,user,service_code)
    if content_list.length > 0
      for i in 0...content_list.length do
        self.send_exam_message( waiting_record,user,content_list[i],service_code)
      end
    else
      unless waiting_record.send_user_id == ''
        self.send_exam_message(waiting_record,user,waiting_record.content,service_code)
      end
    end
  end

  def self.generate_message(content_list,waiting_record,user,service_code)
    if content_list.length > 0
      for i in 0...content_list.length do
        self.generate_send_message( waiting_record,user,content_list[i],service_code)
      end
    else
      unless waiting_record.send_user_id == ''
        self.generate_send_message(waiting_record,user,waiting_record.content,service_code)
      end
    end
  end
end