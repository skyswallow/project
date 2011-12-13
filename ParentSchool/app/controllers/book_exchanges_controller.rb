class BookExchangesController < ApplicationController
  layout "book_activity"
  skip_before_filter :verify_authenticity_token
  def index
    @book_exchange = BookExchange.paginate :page => params[:page], :per_page => 15, :order => "is_finished, created_at desc"
    @current_book_exchange = BookExchange.current_book_exchange(@book_exchange)
    session[:id] = '0'
    session[:exchange_type] = nil
  end

  def search_user_name
    p params[:search_user_name]
    str = ""
    if params[:search_user_name]
      @book_active_info = BookActivity.find(:first, :conditions => ["target_cellphone = ?",params[:search_user_name].strip])
      if @book_active_info
        if params[:user_status].to_i ==0 && (@book_active_info.status ==0 || @book_active_info.status == 1 || @book_active_info.status == 2)
          #该状态
          @book_active_info.update_attributes(:status => 3) if @book_active_info.status ==0
          @book_active_info.update_attributes(:status => 5) if @book_active_info.status ==1
          @book_active_info.update_attributes(:status => 6) if @book_active_info.status ==2
          ActionRecord.create_action_record(params[:search_user_name].strip,
            Constant::ACTION_TYPE[4][0],
            Constant::ACTION_RESULT[12][0])
        end
        if @book_active_info.status == 0 || @book_active_info.status == 1 || @book_active_info.status == 2
          str = "请在发布获赠信息前填写一份关于您孩子学习情况的调查问卷，谢谢！"+":"+@book_active_info.target_cellphone.to_s+":"+@book_active_info.status.to_s
        elsif @book_active_info.status == 3 || @book_active_info.status == 6
          str ="show"+":"+ "您暂未获得图书，可选择下列图书中的一本要求获赠。"
        elsif @book_active_info.book_code && (@book_active_info.status == 4 || @book_active_info.status == 5)
          str ="display"+":"+ "您已获得《#{ Constant::All_BOOKS[@book_active_info.book_code-1][1]}》，可通过发布交换信息，申请交换其他图书。<br>请选择下列希望换取的图书，点击“申请交换”按钮，发布交换信息。"
        end

      else
        str = "<font color='red'>您不能参与交换或赠予活动!</font>"
      end
    else
      str = "<font color='red'>您不能参与交换或赠予活动!</font>"
    end
    render :text => str
    #render :partial => "current_book_exchange", :locals  => {:str => str, :current_book_total => current_book_total,:current_book => (@book_active_info.book_code if @book_active_info)}
  end

  def current_book
    if params[:search_user_name]
      book_active_info = BookActivity.find(:first, :conditions => ["target_cellphone = ?",params[:search_user_name].strip])
      if book_active_info
        current_book_total =  BookExchange.find_all_by_apply_user_and_is_finished(params[:search_user_name].strip,0)
        local_str = params[:str]
      else
        local_str = "您不能参与交换或赠予活动"
      end
    else
      local_str = "您不能参与交换或赠予活动"
    end
    render :partial => "current_book", :locals  => {:local_str => local_str, :current_book_total => current_book_total,:current_book => book_active_info}
  end

  def create
    str =""
    if params[:username]
      @book_active_info = BookActivity.find(:first, :conditions => ["target_cellphone = ?",params[:username].strip])
      first_book_code = nil
      flag1 = false
      flag2 = false
      if @book_active_info
        first_book_code = @book_active_info.book_code
        if params[:book_name]
          if @book_active_info.status != BookActivity::STATUS[:FAIL] and @book_active_info.status != BookActivity::STATUS[:FAIL_BUT_ASK] and params[:book_name] == @book_active_info.book_code.to_s
            str = "您已经获赠该图书，无需#{BookExchange. return_info(@book_active_info)}，谢谢！"
          elsif !BookExchange.find_by_apply_user_and_reply_book_and_exchange_type_and_is_finished(params[:username].strip, params[:book_name],0,0).blank?
            str = "您已经提交过该图书的#{BookExchange. return_info(@book_active_info)}，无需重复提交，谢谢！"
          elsif !BookExchange.find_by_apply_user_and_apply_book_and_exchange_type_and_is_finished(params[:username].strip, params[:book_name],1,0).blank?
            str = "您已经提交过该图书的#{BookExchange. return_info(@book_active_info)}，无需重复提交，谢谢！"
          elsif params[:jh_or_hz].to_i ==1 and (@book_active_info.status == 4 or @book_active_info.status == 5)
            book_exchange = BookExchange.new
            book_exchange.apply_user = params[:username].strip
            book_exchange.apply_book = @book_active_info.book_code
            book_exchange.reply_book = params[:book_name]
            book_exchange.exchange_type = 0
            book_exchange.is_finished = 0
            if book_exchange.save
              str = "交换申请已提交成功"
              flag1 = true
            else
              str = "交换申请提交失败"
            end
          elsif params[:jh_or_hz].to_i==0 and ( @book_active_info.status == 3 or @book_active_info.status == 6)
            book_exchange = BookExchange.new
            book_exchange.apply_user = params[:username].strip
            book_exchange.apply_book = params[:book_name]
            book_exchange.exchange_type = 1
            book_exchange.is_finished = 0
            if book_exchange.save
              str = "申领获赠已提交成功"
              flag2 = true
            else
              str = "申领获赠提交失败"
            end
          else
            str ="操作失败"
          end
        else
          str = "必须选择图书选项"
        end
      else
        str = "<font color='red'>您不能参与交换或赠予活动!</font>"
      end
      if params[:jh_or_hz].to_i == 1
        if flag1
          ActionRecord.create_action_record(params[:username].strip, 
            Constant::ACTION_TYPE[2][0],
            Constant::ACTION_RESULT[5][0],
            first_book_code,
            params[:book_name])
        else
          ActionRecord.create_action_record(params[:username].strip, 
            Constant::ACTION_TYPE[2][0],
            Constant::ACTION_RESULT[4][0],
            first_book_code,
            params[:book_name])
        end
      elsif params[:jh_or_hz].to_i == 0
        if flag2
          ActionRecord.create_action_record(params[:username].strip,
            Constant::ACTION_TYPE[3][0],
            Constant::ACTION_RESULT[9][0],
            params[:book_name])
        else
          ActionRecord.create_action_record(params[:username].strip,
            Constant::ACTION_TYPE[3][0],
            Constant::ACTION_RESULT[8][0],
            params[:book_name])
        end
      end
    else
      str = "<font color='red'>您不能参与交换或赠予活动!</font>"
    end
    render :text => str
  end

  def destroy
    if params[:search_user_name]
      book_active_info = BookActivity.find(:first, :conditions => ["target_cellphone = ?",params[:search_user_name].strip])
      book_exchange = BookExchange.find(:first, :conditions => ["id = ?",params[:id]])
      if book_active_info
        if book_exchange
          if book_exchange.is_finished.to_i == 0
            if !book_exchange.destroy
              str = "操作失败"
            end
          else
            str = '交换或赠予已经完成！'
          end
        else
          str = '该记录已经被删除！'
        end
        if str.blank?
          if book_active_info.status == 3 || book_active_info.status == 6
            str = "您暂未获得图书，可选择下列图书中的一本要求获赠。"
          elsif book_active_info.book_code && (book_active_info.status == 4 || book_active_info.status == 5)
            str = "您已获得《#{ Constant::All_BOOKS[book_active_info.book_code-1][1]}》，可通过发布交换信息，申请交换其他图书。<br>请选择下列希望换取的图书，点击“申请交换”按钮，发布交换信息。"
          end
        end
      else
        str = "您不能参与交换或赠予活动"
      end
    else
      str = "您不能参与交换或赠予活动"
    end
    current_book_total =  BookExchange.find_all_by_apply_user_and_is_finished(params[:search_user_name].strip,0)
    render :partial => "current_book", :locals  => {:local_str => str, :current_book_total => current_book_total,:current_book => book_active_info  }
  end

  def jiaohuan
    str =""
    if params[:user_name]
      book_active_info = BookActivity.find(:first, :conditions => ["target_cellphone = ?",params[:user_name].strip])#jiaohuan应答人
      book_exchange = BookExchange.find_by_id_and_exchange_type(params[:apply_user_info],BookExchange::CHANGE_TYPE[:J]) #jiaohuan申请人
      first_book_code = nil
      flag = false
      BookActivity.transaction  do
        BookExchange.transaction do
          if book_active_info
            first_book_code = book_active_info.book_code
            if book_active_info.status != 1 and  book_active_info.status != 0 and  book_active_info.status != 2
              if book_exchange
                if book_exchange.is_finished ==0
                  if book_active_info.status != BookActivity::STATUS[:FAIL] and book_active_info.status != BookActivity::STATUS[:FAIL_BUT_ASK] and book_exchange.reply_book == book_active_info.book_code
                    book_exchange.update_attribute(:reply_user, book_active_info.target_cellphone)
                    books_apply = BookExchange.find_all_by_apply_user_and_is_finished(book_exchange.apply_user,0)
                    books_reply = BookExchange.find_all_by_apply_user_and_is_finished(params[:user_name].strip,0)
                    (books_apply || []).each do |book|
                      book.update_attribute(:is_finished, 1)
                    end
                    (books_reply || []).each do |book|
                      book.update_attribute(:is_finished, 1)
                    end
                    book_apply = BookActivity.find(:first, :conditions => ["target_cellphone = ?",book_exchange.apply_user])
                    code_temp = book_apply.book_code
                    book_apply.update_attribute(:book_code, book_active_info.book_code)
                    book_active_info.update_attribute(:book_code, code_temp)
                    str = "恭喜，交换成功！您的其他的交换申请同时关闭。"
                    flag = true
                  else
                    str = "抱歉，您不符合交换条件，交换失败。"
                  end
                else
                  str = "你选择的图书被其他用户换走，请重新选择"
                end
              else
                str = '该请求已被删除！'
              end
            else
              str = "请在交换图书前填写一份关于您孩子学习情况的调查问卷，谢谢！"
              str = str +"||"+ "#{Constant::SITE_URL}/book_activities/survey?s=#{book_active_info.status}&type=2&name=#{book_active_info.target_cellphone}"
            end
          else
            str = "抱歉，您不符合交换条件，交换失败。"
          end
        end
      end
      if flag
        ActionRecord.create_action_record(params[:user_name].strip, 
          Constant::ACTION_TYPE[2][0],
          Constant::ACTION_RESULT[7][0],
          first_book_code,
          book_exchange.apply_book)
      else
        ActionRecord.create_action_record(params[:user_name].strip, 
          Constant::ACTION_TYPE[2][0],
          Constant::ACTION_RESULT[6][0],
          first_book_code,
          book_exchange.apply_book)
      end
    else
      str = "抱歉，您不符合交换条件，交换失败。"
    end
    #    flash[:message] = str
    render :text => str
  end

  def zengyu
    str =""
    if params[:user_name]
      book_active_info = BookActivity.find(:first, :conditions => ["target_cellphone = ?",params[:user_name].strip])#赠予应答人
      book_exchange = BookExchange.find_by_id_and_exchange_type(params[:apply_user_info],BookExchange::CHANGE_TYPE[:Z]) #赠予申请人
      flag = false
      BookActivity.transaction do
        BookExchange.transaction do
          if book_active_info
            if book_exchange
              book_apply_info = BookActivity.find(:first, :conditions => ["target_cellphone = ?",book_exchange.apply_user])
              if book_exchange.is_finished ==0
                if book_apply_info and book_active_info.status != BookActivity::STATUS[:FAIL] and book_active_info.status != BookActivity::STATUS[:FAIL_BUT_ASK] and book_exchange.apply_book == book_active_info.book_code
                  book_exchange.update_attribute(:reply_user, book_active_info.target_cellphone)
                  books_apply = BookExchange.find_all_by_apply_user_and_is_finished(book_exchange.apply_user,0)
                  books_reply = BookExchange.find_all_by_apply_user_and_is_finished(params[:user_name].strip,0)
                  (books_apply || []).each do |book|
                    book.update_attribute(:is_finished, 1)
                  end
                  (books_reply || []).each do |book|
                    book.update_attribute(:is_finished, 1)
                  end
                  book_apply_info.update_attributes(:book_code => book_active_info.book_code, :status => book_active_info.status)
                  book_active_info.update_attributes(:book_code => "", :status => 3)
                  str = "恭喜，赠予成功！您的其他的交换申请同时关闭。"
                  flag = true
                elsif  book_apply_info and (book_apply_info.status ==4 or book_apply_info.status ==5)
                  (BookExchange.find_all_by_apply_user_and_is_finished(book_exchange.apply_user,0) || []).each do |book|
                    book.update_attribute(:is_finished, 1)
                  end
                  str ="已经拥有图书，请重新选择"
                else
                  str ="抱歉，您不符合赠予条件，赠予失败。"
                end
              else
                (BookExchange.find_all_by_apply_user_and_is_finished(book_exchange.apply_user,0) || []).each do |book|
                  book.update_attribute(:is_finished, 1)
                end
                str = "该用户已经拥有图书，请重新选择"
              end
            else
              str = '该请求已被删除！'
            end
          else
            str = "抱歉，您不符合赠予条件，赠予失败。"
          end
        end
      end
      if flag
        ActionRecord.create_action_record(params[:user_name].strip,
          Constant::ACTION_TYPE[3][0],
          Constant::ACTION_RESULT[11][0],
          book_exchange.apply_book)
      else
        unless book_active_info.blank?
          ActionRecord.create_action_record(params[:user_name].strip,
           Constant::ACTION_TYPE[3][0],
            Constant::ACTION_RESULT[10][0],
           book_active_info.book_code)
        else
          ActionRecord.create_action_record(params[:user_name].strip,
            Constant::ACTION_TYPE[3][0],
            Constant::ACTION_RESULT[10][0])
        end
      end
    else
      str = "抱歉，您不符合赠予条件，赠予失败。"
    end
    render :text => str
  end

  def select_book
    if params[:page].nil?
      if params[:id]
        if  [0,1,2,3].include?(params[:id].to_i)
          session[:id] = params[:id].to_i
        elsif params[:id].to_i == 4
          session[:exchange_type] = 0
        elsif params[:id].to_i == 5
          session[:exchange_type] = 1
        elsif params[:id].to_i ==6
          session[:id] = 0
          session[:exchange_type] = nil
        end
      end
    end
    if session[:id].to_i ==0
      if session[:exchange_type]
        p "111111"
        @book_exchange = BookExchange.paginate :page => params[:page], :per_page => 15, :order => "is_finished, created_at desc", :conditions => "exchange_type =#{session[:exchange_type].to_i}"
      else
        @book_exchange = BookExchange.paginate :page => params[:page], :per_page => 15, :order => "is_finished, created_at desc"
      end
    else
      if session[:exchange_type]
        @book_exchange = BookExchange.paginate :page => params[:page], :per_page => 15, :order => "is_finished, created_at desc", :conditions => "(apply_book =#{session[:id]} or reply_book = #{session[:id]}) and exchange_type =#{session[:exchange_type].to_i}"
      else
        @book_exchange = BookExchange.paginate :page => params[:page], :per_page => 15, :order => "is_finished, created_at desc", :conditions => "apply_book =#{session[:id]} or reply_book = #{session[:id]}"
      end
    end
    @current_book_exchange = BookExchange.current_book_exchange(@book_exchange)
    render :partial => 'change_book'
  end

  def get_user_status
    if params[:search_user_name]
      ba = BookActivity.first(:conditions => ["target_cellphone = ? ", params[:search_user_name].strip])
      if ba
        render :inline => [0,1,2].include?(ba.status) ? 0 : 1
      else
        render :inline =>  -1
      end
    else
      render :inline =>  -1
    end
  end
end
