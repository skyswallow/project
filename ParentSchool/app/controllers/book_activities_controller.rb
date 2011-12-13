class BookActivitiesController < ApplicationController
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
    params[:username] = "0513" + params[:username] if params[:username] and params[:username].strip.size == 8
    return_str = BookActivity.apply(params[:username], params[:book_id])
    if  return_str.include?("恭喜！")
      ActionRecord.create_action_record(params[:username].strip,
        Constant::ACTION_TYPE[0][0],
        Constant::ACTION_RESULT[1][0],
        params[:book_id])
    else
      ActionRecord.create_action_record(params[:username].strip,
        Constant::ACTION_TYPE[0][0],
        Constant::ACTION_RESULT[0][0],
        params[:book_id])
    end
    render :text => return_str
  end

  def lottery
    params[:name] = "0513" + params[:name] if params[:name] and params[:name].strip.size == 8
    @user_info = "#{params[:s]}:#{params[:type]}:#{params[:name]}"
  end

  def survey
    params[:user] = "0513" + params[:user] if params[:user] and params[:user].strip.size == 8
    @user_info = "#{params[:s]}:#{params[:type]}:#{params[:name]}"
  end

  def change_status
    if params[:user_info].split(":")[2] != ""
      params[:user_info].split(":")[2] = params[:user_info].split(":")[2].strip
      params[:user_info].split(":")[2] = "0513" + params[:user_info].split(":")[2] if params[:user_info].split(":")[2] !="" and params[:user_info].split(":")[2].size == 8
      ba = BookActivity.first(:conditions => ["target_cellphone = ? ", params[:user_info].split(":")[2].strip])
      ActionRecord.create_action_record(params[:user_info].split(":")[2].strip,
          Constant::ACTION_TYPE[4][0],
          Constant::ACTION_RESULT[12][0])
      if ba
        if params[:user_info].split(":")[0]
          ba.update_attribute(:status, BookActivity::STATUS[:SUCCESS_AND_ASK]) if params[:user_info].split(":")[0].to_i == 1
          ba.update_attribute(:status, BookActivity::STATUS[:FAIL_BUT_ASK]) if params[:user_info].split(":")[0].to_i == 2
          ba.update_attribute(:status, BookActivity::STATUS[:ASK]) if params[:user_info].split(":")[0].to_i == 0
          if params[:user_info].split(":")[0].to_i == 7 or params[:user_info].split(":")[0].to_i == 8
            ba.update_attribute(:status, BookActivity::STATUS[:FAIL_BUT_ASK]) if ba.status == 2
            ba.update_attribute(:status, BookActivity::STATUS[:ASK]) if ba.status == 0
          end
        end
      end
    end
  end

  def do_lottery
    #    p "eeee",params[:username],params[:is_survey].to_i
    params[:username] = "0513" + params[:username] if params[:username] and params[:username].strip.size == 8
    ba = BookActivity.first(:conditions => ["target_cellphone = ? ", params[:username].strip])
    first_book_code = nil
    flag = false
    if ba
      if ba.real_count.to_i > 0
        ls = LotterySetting.find_by_active_date(Date.today)
        if ((ba.status == 0 or ba.status == 2) and params[:is_survey].to_i == 1) or ba.status == 4 or ba.status == 5
          render :js => "set_alert(#{ba.status});"
        elsif ba.status == 1
          render :js => "set_alert(9,1,2,'#{ba.target_cellphone}');"
        else
          if params[:is_survey] and ls.mk_lottery(ba, params[:is_survey])
            BookExchange.set_exchanges_finished(ba.target_cellphone)
            first_book_code = ba.book_code
            flag = true
            render :js => "set_alert(10,-1,-1,-1,'#{Constant::All_BOOKS[ba.book_code - 1][1]}');"
          else
            if ba.status == BookActivity::STATUS[:INVITE] and params[:is_survey].to_i == 0
              ba.update_attributes(:real_count => ba.real_count.to_i - 1, :status => BookActivity::STATUS[:ASK])
            elsif ba.status == BookActivity::STATUS[:FAIL] and params[:is_survey].to_i == 0
              ba.update_attributes(:real_count => ba.real_count.to_i - 1, :status => BookActivity::STATUS[:FAIL_BUT_ASK])
            else
              ba.update_attributes(:real_count => ba.real_count.to_i - 1)
            end
            render :js => "set_alert(8);"
          end
        end
      else
        if ba.status == 1
          render :js => "set_alert(9,1,2,'#{ba.target_cellphone}');"
        elsif ba.status == 4 or ba.status == 5
          render :js => "set_alert(#{ba.status});"
        else
          render :js => "set_alert(7);"
        end
      end
    else
      render :js => "set_alert(-1);"
    end
    if flag
      ActionRecord.create_action_record(params[:username].strip,
        Constant::ACTION_TYPE[1][0],
        Constant::ACTION_RESULT[3][0],
        first_book_code)
      if params[:is_survey].to_i == 0
        ActionRecord.create_action_record(params[:username].strip,
          Constant::ACTION_TYPE[4][0],
          Constant::ACTION_RESULT[12][0])
      end
    else
      unless ba and (ba.status == 0 or ba.status == 2) and params[:is_survey].to_i == 1
        ActionRecord.create_action_record(params[:username].strip,
          Constant::ACTION_TYPE[1][0],
          Constant::ACTION_RESULT[2][0],
        first_book_code)
      end
    end
  end

  def award_search
    params[:username] = "0513" + params[:username] if params[:username] and params[:username].strip.size == 8
    ba = BookActivity.first(:conditions => ["target_cellphone = ? ", params[:username].strip])
    if ba and (ba.status == BookActivity::STATUS[:SUCCESS] or
          ba.status == BookActivity::STATUS[:SUCCESS_AND_ASK] or ba.status == BookActivity::STATUS[:LOTTERY])
      render :js => "alert_award(1,'#{Constant::All_BOOKS[ba.book_code - 1][1]}');"
    else
      render :js => "alert_award(0);"
    end    
  end

  def award_list
    @award_list = BookActivity.award_list
  end

  def get_user_status
    ba = BookActivity.first(:conditions => ["target_cellphone = ? ", params[:username].strip])
    render :inline => ba.nil?? -1 : ba.status
  end
  
  def download
    if !params[:id].nil?
      url = "#{RAILS_ROOT}/public/data/week_awards/week_#{params[:id]}.txt"
      send_file url
    else
      redirect_to book_plans_url
    end
  end
end
