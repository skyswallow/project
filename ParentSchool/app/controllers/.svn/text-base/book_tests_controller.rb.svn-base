class BookTestsController < ApplicationController
  layout "book_activity"
  
  def index
    @has_book = BookSetting.has_books(Time.now)    
    @activity_time = [Time.now.to_i,Time.mktime(2010,11,1,19,00,00).to_i,Time.mktime(2010,12,31,21,00,00).to_i]
    if @activity_time[0] > @activity_time[1] and @activity_time[0] < @activity_time[2]
      @time_now = [Time.now.to_i,Time.mktime(Time.now.year,Time.now.month,Time.now.day,19,00,00).to_i,Time.mktime(Time.now.year,Time.now.month,Time.now.day,21,00,00).to_i]
    else
      @time_now = [Time.now.to_i,@activity_time[1],@activity_time[2]]
    end
  end

  def apply
    str = ""
    type = 0
    is_grade_parent = 0
    if 19 <= Time.now.strftime("%H").to_i and  Time.now.strftime("%H").to_i < 21
      if params[:username]
        if params[:book_id]
          ba = BookActivity.first(:conditions => ["username = ? and active_date=to_date('#{Time.now.to_date.to_s}','yyyy-mm-dd') ", params[:username].strip])
          BookActivity.transaction do
            BookSetting.transaction do
              if ba
                if ba.status == BookActivity::STATUS[:SUCCESS]
                  type = 3
                  str = "您已经申领过图书。因图书数量有限，您不能再次申领。谢谢！"
                else
                  bs = BookSetting.find_all_by_book_code(params[:book_id].to_i, :conditions => "created_at=to_date('#{Time.now.to_date.to_s}','yyyy-mm-dd')", :order => "created_at desc")[0]
                  if bs.total_count.to_i > bs.real_count.to_i
                    ba.update_attributes(:status => BookActivity::STATUS[:SUCCESS], :book_code => params[:book_id].to_i)
                    bs.update_attribute(:real_count, bs.real_count.to_i + 1)
                    type = 6
                    str = "恭喜！您已成功申领图书《#{All_BOOKS[params[:book_id].to_i - 1][1]}》，图书将在整个活动结束后，由您孩子所在学校送达。"
                  else
                    ba.update_attributes(:status => BookActivity::STATUS[:FAIL], :book_code => params[:book_id].to_i)
                    type = 4
                    str = "很抱歉，您选择的图书已全部被申领完。谢谢！"
                  end
                end
                if ba.parent_type == BookActivity::PARENTTYPE[:T]
                  is_grade_parent = 1
                end
                type = 5 if is_grade_parent == 1 and type == 6
              else
                type = 2
                str = "因赠书采取分批申领，您暂不能参与此批图书申领，请您根据短信内容中提供的申领日期进行申领。谢谢！"
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
      type = 7
      str = "抱歉，申领尚未开始！"
    elsif 21 <= Time.now.strftime("%H").to_i
      type = 8
      str = "抱歉，申领已经结束！"
    end
    render :text => type.to_s + ":" + is_grade_parent.to_s + ":" + str
  end

end
