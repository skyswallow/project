class BookPlansController < ApplicationController
  layout "book_activity"
  
  def apply
    str = ""
    type = 0
    is_grade_parent = 0
    if params[:username]
      if params[:book_id]
        ba = BookActivity.first(:conditions => ["username = ? ", params[:username].strip])
        BookActivity.transaction do
          BookSetting.transaction do
            if ba
              if ba.status == BookActivity::STATUS[:SUCCESS]
                type = 3
                str = "您已中奖并将获赠图书。因图书数量有限，您不能再次申领。谢谢配合！"
              elsif ba.status == BookActivity::STATUS[:FAIL]
                type = 7
                str = "您已提交过图书申领请求，无需重复提交。请在每周一公布的【获奖信息】中查询中奖结果。谢谢您的参与！"
              else
                ba.update_attributes(:status => BookActivity::STATUS[:FAIL], :book_code => params[:book_id].to_i)
                type = 6
                str = "您已成功提交图书申领请求，请在每周一公布的【获奖信息】中查询中奖结果。谢谢您的参与！"
              end
              if ba.parent_type == BookActivity::PARENTTYPE[:T]
                is_grade_parent = 1
              end
              type = 5 if is_grade_parent == 1 and type == 6
            else
              type = 2
              str = "非常抱歉，您不在此次活动范围内，请关注我们的其他活动。"
            end
          end
        end
      else
        str = "请您选择一本要申领的图书，谢谢！"
      end
    else
      str = "请输入您的网上家长学校的账号，谢谢！"
    end
    render :text => type.to_s + ":" + is_grade_parent.to_s + ":" + str
  end

  def award_list
    @award_list = []
    Dir.entries(RAILS_ROOT + "/public/data/reports").each do |file|
      if file!="." and file!='..' and file!=".svn"
        @award_list << file.split(".")[0].to_i
      end
    end
    @award_list = @award_list.sort { |a,b| a <=> b }.collect { |obj| ["第#{obj + 1}期",obj] }
  end

  def download
    if !params[:id].nil?
      url = "#{RAILS_ROOT}/public/data/reports/#{params[:id]}.txt"
      send_file url
    else
      redirect_to book_plans_url
    end
  end

end
