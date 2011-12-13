class PageRecord < ActiveRecord::Base  

  EXCEL_PATH  = "#{RAILS_ROOT}/public/data/reports/excel-file.xls"

  TIME_DUAN = "00,'00:00~01:00',
    01,'01:00~02:00',
    02,'02:00~03:00',
    03,'03:00~04:00',
    04,'04:00~05:00',
    05,'05:00~06:00',
    06,'06:00~07:00',
    07,'07:00~08:00',
    08,'08:00~09:00',
    09,'09:00~10:00',
    10,'10:00~11:00',
    11,'11:00~12:00',
    12,'12:00~13:00',
    13,'13:00~14:00',
    14,'14:00~15:00',
    15,'15:00~16:00',
    16,'16:00~17:00',
    17,'17:00~18:00',
    18,'18:00~19:00',
    19,'19:00~20:00',
    20,'20:00~21:00',
    21,'21:00~22:00',
    22,'22:00~23:00',
    23,'23:00~00:00'"

  PAGE_TIME = ['00:00~01:00',
    '01:00~02:00',
    '02:00~03:00',
    '03:00~04:00',
    '04:00~05:00',
    '05:00~06:00',
    '06:00~07:00',
    '07:00~08:00',
    '08:00~09:00',
    '09:00~10:00',
    '10:00~11:00',
    '11:00~12:00',
    '12:00~13:00',
    '13:00~14:00',
    '14:00~15:00',
    '15:00~16:00',
    '16:00~17:00',
    '17:00~18:00',
    '18:00~19:00',
    '19:00~20:00',
    '20:00~21:00',
    '21:00~22:00',
    '22:00~23:00',
    '23:00~00:00']
  
  def self.find_date(find_date)
    find_date = find_date.to_i
    if find_date.blank? || find_date == 0
      ["=to_char('#{Date.today}')", Date.today]
    elsif find_date == 1
      ["=to_char('#{Date.today - 1}')", Date.today - 1]
    elsif find_date == 2
      [">=to_char('#{Date.today - 6}')", Date.today - 6]
    elsif find_date == 3
      [">=to_char('#{Date.today - 29}')", Date.today - 29]
    end
  end

  def self.sort_pages(sort)
    case sort
    when "pv"  then "pv DESC"
    when "uv"   then "uv DESC"
    when "ip" then "ip DESC"
    when "pv_reverse"  then "pv ASC"
    when "uv_reverse"   then "uv ASC"
    when "ip_reverse" then "ip ASC"
    else  "pv DESC"
    end
  end

  def self.sort_times(sort)
    case sort
    when "time_duan"  then "time_duan DESC"
    when "pv"  then "pv DESC"
    when "uv"   then "uv DESC"
    when "ip" then "ip DESC"
    when "num" then "num DESC"
    when "stay_date" then "stay_date DESC"
    when "time_duan_reverse"  then "time_duan ASC"
    when "pv_reverse"  then "pv ASC"
    when "uv_reverse"   then "uv ASC"
    when "ip_reverse" then "ip ASC"
    when "num_reverse" then "num ASC"
    when "stay_date_reverse" then "stay_date ASC"
    else  "time_duan ASC"
    end
  end

  def self.sort_records(sort)
    case sort
    when "created_at"  then "created_at ASC"
    when "action_type"   then "action_type ASC"
    when "action_result" then "action_result ASC"
    when "first_book_code" then "first_book_code ASC"
    when "spreader_phone" then "spreader_phone ASC"
    when "created_at_reverse"  then "created_at DESC"
    when "action_type_reverse"   then "action_type DESC"
    when "action_result_reverse" then "action_result DESC"
    when "first_book_code_reverse" then "first_book_code DESC"
    when "spreader_phone_reverse" then "spreader_phone DESC"
    else  "created_at DESC"
    end
  end
  
  def self.check_date(start_time, end_time)
    unless start_time.blank?
      unless end_time.blank?
        " and (to_char(to_date(trunc(created_at)),'yyyy-mm-dd') between to_char('#{start_time}') and to_char('#{end_time}') )"
      else
        " and (to_char(to_date(trunc(created_at)),'yyyy-mm-dd') between to_char('#{start_time}') and to_char('#{Date.today.to_s('yyyy-mm-dd')}') )"
      end
    else
      unless end_time.blank?
        " and (to_char(to_date(trunc(created_at)),'yyyy-mm-dd') <= to_char('#{end_time}'))"
      end
    end
  end

  def self.check_xls_date(start_time, end_time, url, find_url)
    conditions = "and referer not like '%.ntjxt.%' and referer is not null  and referer like '%#{find_url.to_s.strip}%'" unless find_url.blank?
    unless start_time.blank?
      unless end_time.blank?
        [start_time, end_time]
      else
        [start_time, Date.today.to_s('yyyy-mm-dd')]
      end
    else
      unless end_time.blank?       
        [self.find(:first, :order => 'created_at', :conditions => "url = '#{url}'#{conditions}").created_at.strftime("%Y-%m-%d"),end_time]
      else
        [self.find(:first, :order => 'created_at', :conditions => "url = '#{url}'#{conditions}").created_at.strftime("%Y-%m-%d"), self.find(:last, :order => "created_at", :conditions => "url = '#{url}'#{conditions}").created_at.strftime("%Y-%m-%d")]
      end
    end
  end

  def self.time_duan(sort, incomming_history)
    sort = PageRecord.sort_times(sort)
    @result = Array.new
    [[], []]
    count = 0
    PageRecord::PAGE_TIME.each { |pt|
      i = 0
      unless incomming_history.blank?
        incomming_history.each { |ih|
          if pt.to_s == ih.time_duan.to_s
            @result[count] = [[pt], [ih.pv.to_i, ih.uv.to_i, ih.ip.to_i, ih.num, ih.stay_date.to_i,1]]
            break
          else
            i += 1
          end
          if i == incomming_history.size
            @result[count] = [[pt], [0, 0, 0, 0, 0]]
          end
        }
      else
        0.upto(23) { |ih|
          @result[count] = [[pt], [0, 0, 0, 0, 0]]
        }
      end
      count += 1
    }
    case sort
    when "time_duan DESC"  then @result.reverse
    when "pv DESC"  then @result.sort { |a,b| b[1][0] <=> a[1][0]  }
    when "uv DESC"   then @result.sort { |a,b| b[1][1] <=> a[1][1]  }
    when "ip DESC" then @result.sort { |a,b| b[1][2] <=> a[1][2]  }
    when "num DESC" then @result.sort { |a,b| b[1][3] <=> a[1][3]  }
    when "stay_date DESC" then @result.sort { |a,b| b[1][4] <=> a[1][4]  }
    when "time_duan ASC"  then @result
    when "pv ASC"  then @result.sort { |a,b| a[1][0] <=> b[1][0]  }
    when "uv ASC"   then @result.sort { |a,b| a[1][1] <=> b[1][1]  }
    when "ip ASC" then @result.sort { |a,b| a[1][2] <=> b[1][2]  }
    when "num ASC" then @result.sort { |a,b| a[1][3] <=> b[1][3]  }
    when "stay_date ASC" then @result.sort { |a,b| a[1][4] <=> b[1][4]  }
    else  @result
    end
  end

  def self.incomming_history(sort, url, find_date, find_url)
    sort = self.sort_pages(sort)
    find_date = self.find_date(find_date)
    conditions = "url = '#{url}' and referer not like '%.ntjxt.%' and referer is not null and to_char(to_date(trunc(created_at)),'yyyy-mm-dd') #{find_date[0]} and referer like '%#{find_url.to_s.strip}%'"
    self.find(:all, :group => 'referer',:order => sort, :conditions => conditions,
      :select => " referer,count(id) pv,count(distinct session_id) uv, count(distinct ip) ip ")
  end

  def self.incomming_high(url, start_time, end_time, find_url, sort)
    date_result = self.check_date(start_time, end_time)
    sort = self.sort_pages(sort)
    conditions = "url = '#{url}' and referer not like '%.ntjxt.%' and referer is not null #{date_result} and referer like '%#{find_url.to_s.strip}%'"
    self.find(:all, :group => 'referer',:order => sort, :conditions => conditions,
      :select => " referer,count(id) pv,count(distinct session_id) uv, count(distinct ip) ip ")
  end

  def self.to_incoming_xls(id, url, start_time, end_time, find_date, total_xls, find_url)
    Page_history.include_spread
    find_date = PageRecord.find_date(find_date)[1].to_s
    workbook = Spreadsheet::Workbook.new
    sheet = workbook.create_worksheet
    sheet.row(0).concat ["受访页面", url]
    unless id.blank?
      xls_date = PageRecord.check_xls_date(start_time, end_time, url, find_url)
      date_time = xls_date[0].to_s+"--"+xls_date[1].to_s
      sheet.row(1).concat ["查询时间段", date_time ]
    else
      if find_date.to_s == (Date.today - 1).to_s
        sheet.row(1).concat ["查询时间段", find_date.to_s+"--"+find_date.to_s]
      else
        sheet.row(1).concat ["查询时间段", find_date.to_s+"--"+Date.today.to_s]
      end
    end
    sheet.row(2).concat %w{来路页面 来访次数 UV IP}
    i = 3
    total_xls.each { |item|sheet.row(i).push item.referer, item.pv, item.uv, item.ip
      i += 1
    }    
    workbook.write EXCEL_PATH
    EXCEL_PATH
  end

  def self.time_statistics(sort, url, find_date)
    find_date = PageRecord.find_date(find_date)
    sort = PageRecord.sort_times(sort)
    PageRecord.find(:all,
      :group => "substr(to_char(created_at,'hh24:mm:ss'),0,2)",
      :order => sort,
      :conditions => "url = '#{url}' and to_char(to_date(trunc(created_at)),'yyyy-mm-dd')#{find_date[0]}",
      :select => "decode(substr(to_char(created_at,'hh24:mm:ss'),0,2),#{TIME_DUAN})time_duan,count(substr(to_char(created_at,'hh24:mm:ss'),0,2)) pv,count(distinct session_id) uv,
    count(distinct ip) ip, trunc(count(id)/count(distinct session_id),2) num, round(sum(stay_time)/count(id),2) stay_date")
  end

  def self.time_statistics_high(url, sort, start_time, end_time)
    date_result = PageRecord.check_date(start_time, end_time)
    sort = PageRecord.sort_times(sort)
    PageRecord.find(:all,
      :group => "substr(to_char(created_at,'hh24:mm:ss'),0,2)",
      :order => sort,
      :conditions => "url = '#{url}' #{date_result}",
      :select => "decode(substr(to_char(created_at,'hh24:mm:ss'),0,2),#{TIME_DUAN})time_duan,count(substr(to_char(created_at,'hh24:mm:ss'),0,2)) pv,count(distinct session_id) uv,
    count(distinct ip) ip, trunc(count(id)/count(distinct session_id),2) num, round(sum(stay_time)/count(id),2) stay_date")
  end

  def self.to_time_xls(sort, id, url, start_time, end_time, find_date, total_xls)
    Page_history.include_spread
    find_date = PageRecord.find_date(find_date)[1].to_s
    total_xls = PageRecord.time_duan(sort,total_xls)
    workbook = Spreadsheet::Workbook.new
    sheet = workbook.create_worksheet
    sheet.row(0).concat ["受访页面", url]
    unless id.blank?
      xls_date = PageRecord.check_xls_date(start_time, end_time, url, nil)
      date_time = xls_date[0].to_s+"--"+xls_date[1].to_s
      sheet.row(1).concat ["查询时间段", date_time ]
    else
      if find_date.to_s == (Date.today - 1).to_s
        sheet.row(1).concat ["查询时间段", find_date.to_s+"--"+find_date.to_s]
      else
        sheet.row(1).concat ["查询时间段", find_date.to_s+"--"+Date.today.to_s]
      end
    end
    sheet.row(2).concat %w{时间段 PV UV IP 人均浏览次数 人均浏览时间（秒）}
    i = 3
    total_xls.each { |item|
      sheet.row(i).push item[0].to_s, item[1][0], item[1][1], item[1][2], item[1][3], item[1][4].to_i
      i += 1
    }
    workbook.write EXCEL_PATH
    EXCEL_PATH
  end

  def self.user_records(target_cellphone)
    self.find_by_sql ["SELECT  gd.name area_name,decode(st.s_type,0,'城市',1,'城镇',2,'农村') s_type,
      decode(substr(gg.code,5,1),1,'幼儿园',2,'小学',3,'初中',4,'高中',5,'大学')  s_group,
        gs.name s_name,gg.name||gc.name class_name,u.target_cellphone cellphone  from users u  inner join parents p on p.id=u.id
        inner join students s on s.id=p.student_id
        inner join user_groups gc on gc.id=s.schoolclass_id
        inner join user_groups gg on gg.id=gc.parent_id
        inner join user_groups gs on gs.id=gg.parent_id
        inner join user_groups gd on gd.id=gs.parent_id
        inner join school_types st on st.school_id=gs.id  WHERE (u.target_cellphone = '#{target_cellphone}') "]
  end

  # page_records 方法,page_time 简单查询时间，start_time_and_end_time 高级查询时间, type=0 简单查询，1为高级查询,3为历史查询
  def self.search_page_records_data page_sort,page_search_addr,page_time,start_time_and_end_time,type, page
    return_data = []
    sort = self.return_sort(page_sort)
    condition = '1=1'
    if !page_search_addr.blank?
      condition = condition + " and url like '%#{page_search_addr.strip}%'"
    end
    if type.to_i == 0  #简单查询
      if !page_time.blank?
        if page_time.to_i == 1
          str_in = (Date.today-1).to_s('yyyy-mm-dd') + " 到 "+(Date.today-1).to_s('yyyy-mm-dd')
          condition = condition + " and (to_char(to_date(trunc(p.created_at)),'yyyy-mm-dd') = to_char('#{(Date.today-1).to_s('yyyy-mm-dd')}'))"
        elsif page_time.to_i ==0
          str_in = (Date.today-page_time.to_i).to_s('yyyy-mm-dd') +"   到   "+ Date.today.to_s('yyyy-mm-dd')
          condition = condition + " and (to_char(to_date(trunc(p.created_at)),'yyyy-mm-dd') = to_char('#{(Date.today).to_s('yyyy-mm-dd')}'))"
        else
          str_in = (Date.today-page_time.to_i).to_s('yyyy-mm-dd') +"   到   "+ Date.today.to_s('yyyy-mm-dd')
          condition = condition + " and (to_char(to_date(trunc(p.created_at)),'yyyy-mm-dd') >= to_char('#{(Date.today-page_time.to_i).to_s('yyyy-mm-dd')}'))"
        end
      else
        str_in = Date.today.to_s('yyyy-mm-dd') + '  到  '+ Date.today.to_s('yyyy-mm-dd')
        condition = condition + " and (to_char(to_date(trunc(p.created_at)),'yyyy-mm-dd') = to_char('#{Date.today.to_s('yyyy-mm-dd')}'))"
      end
    else   #高级查询
      if !start_time_and_end_time[0].blank? 
        if !start_time_and_end_time[1].blank?
          str_in = start_time_and_end_time[0]+'   到   '+start_time_and_end_time[1]
          condition = condition + " and (to_char(to_date(trunc(p.created_at)),'yyyy-mm-dd') between to_char('#{start_time_and_end_time[0]}') and to_char('#{start_time_and_end_time[1]}') )"
        else
          str_in = start_time_and_end_time[0]+'   到    '+Date.today.to_s('yyyy-mm-dd')
          condition = condition + " and (to_char(to_date(trunc(p.created_at)),'yyyy-mm-dd') between to_char('#{start_time_and_end_time[0]}') and to_char('#{Date.today.to_s('yyyy-mm-dd')}') )"
        end
      else
        if !start_time_and_end_time[1].blank?
          str_in = PageRecord.find(:first,:order => "created_at", :conditions => condition).created_at.strftime("%Y-%m-%d").to_s+"  到   "+ start_time_and_end_time[1]
          condition = condition + " and (to_char(to_date(trunc(p.created_at)),'yyyy-mm-dd') <= to_char('#{start_time_and_end_time[1]}'))"
        else
          str_in = PageRecord.find(:first,:order => "created_at",:conditions => condition).created_at.strftime("%Y-%m-%d").to_s+"  到   "+PageRecord.find(:first, :order => "created_at desc").created_at.strftime("%Y-%m-%d").to_s
        end
      end
    end
    sql = "select  url,count(id) pv,count(distinct session_id) uv, count(distinct ip) ip,round(count(id)/count(distinct session_id),2) num, round(sum(stay_time)/count(id),2) stay_date from page_records p where "+condition+" group by url order by #{sort}"
    unless page.blank?
      return_data[0] = self.paginate_by_sql(sql, :page => page, :per_page => 20)
    else
      return_data[0] = self.find_by_sql(sql)
    end 
    return_data[1] = str_in
    return return_data
  end

  def self.page_records_to_excel page_records, view_date
    e_book = Spreadsheet::Workbook.new
    e_sheet = Spreadsheet::Worksheet.new :name => "a"
    e_sheet.insert_row 0,['查询时间段',view_date]
    e_sheet.insert_row 2,['受访页面','PV','UV','IP','人均浏览次数','人均浏览时间']
    rows =3
    page_records.each do |recorde|
      e_sheet.insert_row rows,[recorde.url,recorde.pv,recorde.uv,recorde.ip,recorde.num,recorde.stay_date.to_i]
      rows = rows + 1
    end
    e_book.add_worksheet e_sheet
    e_book.write "#{RAILS_ROOT}/public/data/reports/b2.xls"
    return "#{RAILS_ROOT}/public/data/reports/b2.xls"
  end

  def self.page_history page_sort, page_url
    sort = !page_sort.blank? ? PageRecord.return_sort(page_sort) :  "to_char(to_date(trunc(p.created_at)),'yyyy-mm-dd') desc"
    if page_url
      @page_recordes = PageRecord.find(:all,
        :group => "to_char(to_date(trunc(p.created_at)),'yyyy-mm-dd')",
        :order => sort, 
        :conditions => "p.url='#{page_url.strip}'",
        :from => "page_records p",
        :select => "to_char(to_date(trunc(p.created_at)),'yyyy-mm-dd') local_time,round(count(id),1) pv,count(distinct session_id) uv, count(distinct ip) ip, round(count(id)/count(distinct session_id),2) num, round(sum(stay_time)/count(id),2) stay_date")
    end
  end

  def self.page_history_to_excel page_records, page_url
    e_book = Spreadsheet::Workbook.new
    e_sheet = Spreadsheet::Worksheet.new :name => "a"
    e_sheet.insert_row 0,['受访页面',page_url]
    e_sheet.insert_row 2,['日期','PV','UV','IP','人均浏览次数','人均浏览时间']
    rows =3
    page_records.each do |recorde|
      e_sheet.insert_row rows,[recorde.local_time,recorde.pv,recorde.uv,recorde.ip,recorde.num,recorde.stay_date.to_i]
      rows = rows + 1
    end
    e_book.add_worksheet e_sheet
    e_book.write "#{RAILS_ROOT}/public/data/reports/b2.xls"
    return "#{RAILS_ROOT}/public/data/reports/b2.xls"
  end

  private
  def self.return_sort sort_value
    sort = case  sort_value
    when "pv_reverse"  then "pv asc"
    when "uv_reverse"   then "uv ASC"
    when "ip_reverse" then "ip ASC"
    when "num_reverse" then "num ASC"
    when "stay_date_reverse" then "stay_date ASC"
    when "pv"  then "pv desc"
    when "uv"   then "uv desc"
    when "ip" then "ip desc"
    when "num" then "num desc"
    when "stay_date" then "stay_date desc"
    else "pv desc"
    end
    return sort
  end
  
end