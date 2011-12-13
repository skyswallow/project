class Contribution < ActiveRecord::Base

  STATUS ={:APPLY => 0, :UNDO => 1, :DO => 2}

  def self.get_status(status)
    case
    when status.to_i == 0
      return "已申请"
    when status.to_i == 1
      return "未发布"
    when status.to_i == 2
      return "已发布"
    end
  end
end
