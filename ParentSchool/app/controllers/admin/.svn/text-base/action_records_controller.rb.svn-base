class Admin::ActionRecordsController < Admin::BaseController
  def index
    @locality = UserGroup.find_all_by_code '0513'
    @school_name = UserGroup.find_by_sql("select * from user_groups ug where  ug.id in (#{params[:school_name_info].chop})") if !params[:school_name_info].blank?
    @class_name = UserGroup.find_by_sql("select gc.id,gg.name||gc.name class_name from user_groups gg inner join user_groups gc on gc.parent_id=gg.id where gc.id in  (#{params[:class_name_info].chop}) and gg.group_category_type!=67") if !params[:class_name_info].blank?
    condition =" 1=1  "
    condition1= '1=1'
    condition_null ="1=1"
    condition2 = "1=1" #没有参加活动的条件
    action_condition =" 1=1 " # 活动条件
    message_condition = " 1=1" #手机条件
    action_condition1 =' 1=1 '
    having="1=1"
    if !params[:class_name_info].blank?
      condition = condition + " and gc.id in (#{params[:class_name_info].chop})"
      condition2 = condition2 + " and gc.id in (#{params[:class_name_info].chop})"
      condition1 = condition1 + " and gc.id in (#{params[:class_name_info].chop})"
      condition_null = condition_null + " and gc.id in (#{params[:class_name_info].chop})"
    end
    if !params[:locality].blank? && params[:locality].to_i != -1
      condition = condition + " and gd.id='#{params[:locality]}'"
      condition2 = condition2 + " and gd.id='#{params[:locality]}'"
      condition_null = condition_null +" and gd.id='#{params[:locality]}'"
      condition1 = condition1 + " and gd.id='#{params[:locality]}'"
    end
    if !params[:school_type].blank? && params[:school_type].to_i !=-1
      condition = condition + " and st.s_type=#{params[:school_type]}"
      condition_null = condition_null +" and st.s_type=#{params[:school_type]}"
      condition2 = condition2 + " and st.s_type=#{params[:school_type]}"
      condition1 = condition1 + " and st.s_type=#{params[:school_type]}"
    end
    if !params[:school_kind].blank? && params[:school_kind].to_i !=-1
      if params[:school_kind].to_i !=5
        condition = condition + "  and substr(gg.group_category_type,0,1)='#{params[:school_kind]}'"
        condition_null = condition_null +"  and substr(gg.group_category_type,0,1)='#{params[:school_kind]}'"
        condition2 = condition2 + "  and substr(gg.group_category_type,0,1)='#{params[:school_kind]}'"
        condition1 = condition1 + "  and substr(gg.group_category_type,0,1)='#{params[:school_kind]}'"
      else
        condition = condition + "  and substr(gg.group_category_type,0,1) not in (1,2,3,4)"
        condition_null = condition_null +"  and substr(gg.group_category_type,0,1) not in (1,2,3,4)"
        condition1 = condition1 + "  and substr(gg.group_category_type,0,1) not in (1,2,3,4)"
      end
    end
    if !params[:school_name_info].blank?
      condition = condition + " and gs.id in (#{params[:school_name_info].chop})"
      condition_null = condition_null +" and gs.id in (#{params[:school_name_info].chop})"
      condition2 = condition2 + " and gs.id in (#{params[:school_name_info].chop})"
      condition1 = condition1 + " and gs.id in (#{params[:school_name_info].chop})"
    end
    if !params[:start_time].blank? && !params[:end_time].blank?
      condition = condition + " and to_char(to_date(trunc(ar.created_at)),'yyyy-mm-dd') between to_char('#{params[:start_time]}') and to_char('#{params[:end_time]}')"
      #   condition1 = condition1 + "  (to_char(to_date(trunc(x.created_at)),'yyyy-mm-dd')) between to_char('#{params[:start_time]}') and to_char('#{params[:end_time]}')"
      action_condition = action_condition + " and  (to_char(to_date(trunc(x.created_at)),'yyyy-mm-dd')) between to_char('#{params[:start_time]}') and to_char('#{params[:end_time]}')"
      action_condition1 = action_condition1 + " and  (to_char(to_date(trunc(bb.created_at)),'yyyy-mm-dd')) between to_char('#{params[:start_time]}') and to_char('#{params[:end_time]}')"

    end
    if !params[:phone_num_info].blank?
      condition = condition + " and ba.target_cellphone in (#{params[:phone_num_info].chop})"
      condition_null = condition_null + " and ba.target_cellphone in (#{params[:phone_num_info].chop})"
      condition2 = condition2 + " and ba.target_cellphone in (#{params[:phone_num_info].chop})"
      condition1 = condition1 + " and a.user_phone in (#{params[:phone_num_info].chop})"
    end

    if !params[:action_type].blank? && params[:action_type].to_i !=-1
      action_condition = action_condition + " and x.action_type= #{params[:action_type]}"
      action_condition1 = action_condition1 + " and bb.action_type= #{params[:action_type]}"
      condition = condition + " and ar.action_type= #{params[:action_type]}"
      if !params[:action_result].blank? && params[:action_result].to_i !=-1 && params[:action_type] !=4
        if params[:action_type].to_i ==2 || params[:action_type].to_i ==3
          action_condition1 = action_condition1 + " and x.action_result= #{params[:action_result]}"
          action_condition = action_condition + " and x.action_result= #{params[:action_result]}"
          condition = condition + " and ar.action_result= #{params[:action_result]}"
          action_condition = action_condition + " and x.action_result = #{params[:action_result]}"
          condition = condition + " and ar.action_result = #{params[:action_result]}"
        else  #type=0,1
          if params[:action_result].to_i==0
            action_condition = action_condition + " and x.action_result = 1" if params[:action_type].to_i ==0
            action_condition = action_condition + " and x.action_result = 3" if params[:action_type].to_i ==1
                action_condition1 = action_condition1 + " and bb.action_result = 1" if params[:action_type].to_i ==0
            condition = condition + " and ar.action_result = 1" if params[:action_type].to_i ==0
            condition = condition + " and ar.action_result = 3" if params[:action_type].to_i ==1
          elsif [1,2,3].include?(params[:action_result].to_i )
            action_condition = action_condition + " and x.action_result = 1 and x.first_book_code=#{params[:action_result]}" if params[:action_type].to_i ==0
            action_condition = action_condition + " and x.action_result = 3 and x.first_book_code=#{params[:action_result]}" if params[:action_type].to_i ==1
             action_condition1 = action_condition1 + " and bb.action_result = 1 and x.first_book_code=#{params[:action_result]}" if params[:action_type].to_i ==0
            action_condition1 = action_condition1 + " and bb.action_result = 3 and x.first_book_code=#{params[:action_result]}" if params[:action_type].to_i ==1
            condition = condition + " and ar.action_result = 1 and ar.first_book_code=#{params[:action_result]}" if params[:action_type].to_i ==0
            condition = condition + " and ar.action_result = 3 and ar.first_book_code=#{params[:action_result]}" if params[:action_type].to_i ==1
          else
            action_condition = action_condition + " and x.action_result=0"   if params[:action_type].to_i ==0
            action_condition = action_condition + " and x.action_result = 2" if params[:action_type].to_i ==1
                        action_condition1 = action_condition1 + " and bb.action_result=0"   if params[:action_type].to_i ==0
            action_condition1 = action_condition1 + " and bb.action_result = 2" if params[:action_type].to_i ==1
            condition = condition + " and ar.action_result=0"   if params[:action_type].to_i ==0
            condition = condition + " and ar.action_result = 2" if params[:action_type].to_i ==1
          end
        end
      end
    end
    if !params[:message_time].blank?
      condition = condition + "and to_char(to_date(trunc(am.created_at)),'yyyy-mm-dd')= '#{params[:message_time]}'"
      condition1 = condition1 + " and  (to_char(to_date(trunc(am.created_at)),'yyyy-mm-dd')) <= '#{params[:message_time]}'"
      message_condition = message_condition +  " and (to_char(to_date(trunc(am1.created_at)),'yyyy-mm-dd'))  = '#{params[:message_time]}'"
      condition2 = condition2 + "and to_char(to_date(trunc(am.created_at)),'yyyy-mm-dd') <= '#{params[:message_time]}'"
    end
    if !params[:message_type_info].blank?
      condition = condition + " and am.message_type in (#{params[:message_type_info].chop})"
      condition2 = condition2 + " and am.message_type in (#{params[:message_type_info].chop})"
      if params[:message_time].blank?
        condition1 = condition1 + " and  (to_char(to_date(trunc(am.created_at)),'yyyy-mm-dd')) <= '#{Date.today.to_s('yyyy-mm-dd')}'"
        message_condition = message_condition +  " and (to_char(to_date(trunc(am1.created_at)),'yyyy-mm-dd'))  = '#{Date.today.to_s('yyyy-mm-dd')}'"
      end
      condition1 = condition1 + " and am.message_type in (#{params[:message_type_info].chop})"
    end
    if !params[:message_count].blank?
      if params[:message_time].blank? 
        condition1 = condition1 + " and  (to_char(to_date(trunc(am.created_at)),'yyyy-mm-dd')) <= '#{Date.today.to_s('yyyy-mm-dd')}'"
        message_condition = message_condition +  " and (to_char(to_date(trunc(am1.created_at)),'yyyy-mm-dd'))  = '#{Date.today.to_s('yyyy-mm-dd')}'"
      end
      having = having+ " and  count(1)= #{params[:message_count]}"
    end
    if params[:message_type_info] == "" || !params[:message_type_info].blank?
      sort = return_sort(params[:sort])
      if params[:message_count].blank? && params[:message_type_info].blank? && params[:message_time].blank?
        if params[:message_time].blank?  && params[:message_type_info].blank?
          sql = "select gd.name area_name,decode(st.s_type,0,'城市',1,'城镇',2,'农村') s_type,gs.name s_name,gg.name||gc.name  class_name,ba.target_cellphone cellphone,uu.display_name display_name, count(ar.user_phone ) r_count from  book_activities ba  left join action_records ar on ba.target_cellphone = ar.user_phone inner join parents p on ba.user_id=p.id left join students s on p.student_id=s.id inner join user_groups gc on s.schoolclass_id=gc.id inner join user_groups gg on gc.parent_id=gg.id  inner join user_groups gs on gg.parent_id=gs.id  inner join user_groups gd on gs.parent_id=gd.id inner join school_types st on gs.id=st.school_id inner join  users uu on ba.user_id = uu.id    where "+condition+" group by gd.name,st.s_type,gs.name,gg.name||gc.name,ba.target_cellphone,uu.display_name order by "+sort
        else
          sql = "select gd.name area_name,decode(st.s_type,0,'城市',1,'城镇',2,'农村') s_type,gs.name s_name,gg.name||gc.name  class_name,ba.target_cellphone cellphone,uu.display_name display_name, count(ar.user_phone ) r_count from  book_activities ba  left join action_records ar on ba.target_cellphone = ar.user_phone inner join parents p on ba.user_id=p.id left join students s on p.student_id=s.id inner join user_groups gc on s.schoolclass_id=gc.id inner join user_groups gg on gc.parent_id=gg.id  inner join user_groups gs on gg.parent_id=gs.id  inner join user_groups gd on gs.parent_id=gd.id inner join school_types st on gs.id=st.school_id inner join  users uu on ba.user_id = uu.id  left join activity_messages am on ba.user_id=am.user_id where "+condition+" group by gd.name,st.s_type,gs.name,gg.name||gc.name,ba.target_cellphone,uu.display_name order by "+sort
        end
      else
        sql = "select  gd.name area_name,decode(st.s_type,0,'城市',1,'城镇',2,'农村') s_type,gs.name s_name,gg.name||gc.name  class_name,a.user_phone cellphone,uu.display_name display_name, ar.r_count r_count,count(1) c from ( select distinct x.user_phone from action_records x  where "+action_condition+"  ) a inner join (select user_phone user_phone,count(*) r_count from action_records  bb where  "+action_condition1+" group by user_phone ) ar on  ar.user_phone=a.user_phone inner join book_activities ba on  ba.target_cellphone = a.user_phone  inner join parents p on ba.user_id=p.id inner join students s on p.student_id=s.id inner join user_groups gc on s.schoolclass_id=gc.id inner join user_groups gg on gc.parent_id=gg.id inner join user_groups gs on gg.parent_id=gs.id inner join user_groups gd on gs.parent_id=gd.id inner join school_types st on gs.id=st.school_id inner join activity_messages am on ba.user_id=am.user_id inner join users uu on ba.user_id = uu.id inner  join (select distinct am1.user_id from activity_messages am1 where "+message_condition+" ) z on  z.user_id=am.user_id where  "+condition1+"   group by gd.name,st.s_type,gs.name,gg.name||gc.name,a.user_phone,uu.display_name, ar.r_count having "+having+" union select  gd.name area_name,decode(st.s_type,0,'城市',1,'城镇',2,'农村') s_type,gs.name s_name,gg.name||gc.name  class_name, ba.target_cellphone  cellphone,uu.display_name display_name,0 r_count,count(1) c from (select distinct am2.user_id from activity_messages am2 where am2.user_id not in (select bac.user_id from book_activities bac where bac.target_cellphone in (select ar2.user_phone from action_records ar2)) ) ar inner join book_activities ba on  ba.user_id=ar.user_id  inner join parents p on ba.user_id=p.id inner join students s on p.student_id=s.id inner join user_groups gc on s.schoolclass_id=gc.id inner join user_groups gg on gc.parent_id=gg.id inner join user_groups gs on gg.parent_id=gs.id inner join user_groups gd on gs.parent_id=gd.id inner join school_types st on gs.id=st.school_id inner join activity_messages am on ba.user_id=am.user_id left join users uu on ba.user_id = uu.id  inner  join (select distinct am1.user_id from activity_messages am1  where "+message_condition+") z on  z.user_id=am.user_id where "+condition2+" group by gd.name,st.s_type,gs.name,gg.name||gc.name, ba.target_cellphone,uu.display_name  having "+having+" order by "+sort
      end
      @action_recordes = ActionRecord.paginate_by_sql(sql, :page => params[:page], :per_page => 30)    
    end   
  end

  def search_school_name
    condition = 'gg.group_category_type!=67 '
    if !params[:locality].blank? &&  params[:locality].to_i != -1
      condition = condition + ' and gd.id='+params[:locality]
    end
    if !params[:school_type].blank? && params[:school_type].to_i != -1
      condition = condition + '  and st.s_type='+params[:school_type]
    end
    if !params[:school_kind].blank? && params[:school_kind].to_i != -1
      if params[:school_kind].to_i !=5
        condition = condition + ' and SUBSTR(gg.code,5,1)='+params[:school_kind]
      else
        condition = condition + ' and SUBSTR(gg.code,5,1) not in (1,2,3,4) and gs.id not in (select gs.id from user_groups gd inner join user_groups gs on gs.parent_id=gd.id inner join user_groups gg on gg.parent_id=gs.id and gg.group_type=5 inner join user_groups gc on gc.parent_id=gg.id where  gg.group_category_type!=67 and  SUBSTR(gg.code,5,1) in(1,2,3,4))'
      end
    end
    p condition
    @school_name = UserGroup.find_by_sql("      select gs.name,gs.id from user_groups gd
 inner join user_groups gs on gs.parent_id=gd.id
 inner join user_groups gg on gg.parent_id=gs.id and gg.group_type=5
 inner join user_groups gc on gc.parent_id=gg.id
 inner join school_types st on st.school_id = gs.id
where "+condition+"
group by gs.name,gs.id  ")
  end

  def search_class_name
    if params[:school_name]
      str = "select gc.id, gs.name , gg.group_category_type grade_id, gs.id school_id,
             gg.name grade_name,gc.name class_name from user_groups gs
             inner join user_groups gg on gg.parent_id=gs.id and gg.group_type=5
             inner join user_groups gc on gc.parent_id=gg.id
             where gs.id in(#{params[:school_name].chop}) and
             gg.group_category_type!=67  order by  gs.name, gg.code, gc.code"
      @schools = UserGroup.find_by_sql("select * from user_groups ug where ug.id in(#{params[:school_name].chop})")
      class_infos = UserGroup.find_by_sql(str)
      @class_arry = Hash.new
      (@schools || []).each do |school|
        @class_arry.keys << school.id
        @class_arry[school.id] = Hash.new
      end
      (class_infos || []).each do |class_info|
        #        p class_info
        if @class_arry[class_info.school_id][class_info.grade_id].nil?
          @class_arry[class_info.school_id][class_info.grade_id] = []
          @class_arry[class_info.school_id][class_info.grade_id] << class_info
        else
          @class_arry[class_info.school_id][class_info.grade_id] << class_info
        end   
      end
      @class_arry.each do |key,value|
        @class_arry[key] = value.to_a.sort { |a,b| a[0] <=> b[0]}
      end
    end
  end


  def to_excel
    Page_history.include_spread
    @locality = UserGroup.find_all_by_code '0513'
    @school_name = UserGroup.find_by_sql("select * from user_groups ug where  ug.id in (#{params[:school_name_info].chop})") if !params[:school_name_info].blank?
    @class_name = UserGroup.find_by_sql("select gc.id,gg.name||gc.name class_name from user_groups gg inner join user_groups gc on gc.parent_id=gg.id where gc.id in  (#{params[:class_name_info].chop}) and gg.group_category_type!=67") if !params[:class_name_info].blank?
    condition =" 1=1  "
    condition1= '1=1'
    condition_null ="1=1"
    condition2 = "1=1" #没有参加活动的条件
    action_condition =" 1=1 " # 活动条件
    message_condition = " 1=1" #手机条件
    action_condition1 =' 1=1 '
    having="1=1"
    if !params[:class_name_info].blank?
      condition = condition + " and gc.id in (#{params[:class_name_info].chop})"
      condition2 = condition2 + " and gc.id in (#{params[:class_name_info].chop})"
      condition1 = condition1 + " and gc.id in (#{params[:class_name_info].chop})"
      condition_null = condition_null + " and gc.id in (#{params[:class_name_info].chop})"
    end
    if !params[:locality].blank? && params[:locality].to_i != -1
      condition = condition + " and gd.id='#{params[:locality]}'"
      condition2 = condition2 + " and gd.id='#{params[:locality]}'"
      condition_null = condition_null +" and gd.id='#{params[:locality]}'"
      condition1 = condition1 + " and gd.id='#{params[:locality]}'"
    end
    if !params[:school_type].blank? && params[:school_type].to_i !=-1
      condition = condition + " and st.s_type=#{params[:school_type]}"
      condition_null = condition_null +" and st.s_type=#{params[:school_type]}"
      condition2 = condition2 + " and st.s_type=#{params[:school_type]}"
      condition1 = condition1 + " and st.s_type=#{params[:school_type]}"
    end
    if !params[:school_kind].blank? && params[:school_kind].to_i !=-1
      if params[:school_kind].to_i !=5
        condition = condition + "  and substr(gg.group_category_type,0,1)='#{params[:school_kind]}'"
        condition_null = condition_null +"  and substr(gg.group_category_type,0,1)='#{params[:school_kind]}'"
        condition2 = condition2 + "  and substr(gg.group_category_type,0,1)='#{params[:school_kind]}'"
        condition1 = condition1 + "  and substr(gg.group_category_type,0,1)='#{params[:school_kind]}'"
      else
        condition = condition + "  and substr(gg.group_category_type,0,1) not in (1,2,3,4)"
        condition_null = condition_null +"  and substr(gg.group_category_type,0,1) not in (1,2,3,4)"
        condition1 = condition1 + "  and substr(gg.group_category_type,0,1) not in (1,2,3,4)"
      end
    end
    if !params[:school_name_info].blank?
      condition = condition + " and gs.id in (#{params[:school_name_info].chop})"
      condition_null = condition_null +" and gs.id in (#{params[:school_name_info].chop})"
      condition2 = condition2 + " and gs.id in (#{params[:school_name_info].chop})"
      condition1 = condition1 + " and gs.id in (#{params[:school_name_info].chop})"
    end
    if !params[:start_time].blank? && !params[:end_time].blank?
      condition = condition + " and to_char(to_date(trunc(ar.created_at)),'yyyy-mm-dd') between to_char('#{params[:start_time]}') and to_char('#{params[:end_time]}')"
      #   condition1 = condition1 + "  (to_char(to_date(trunc(x.created_at)),'yyyy-mm-dd')) between to_char('#{params[:start_time]}') and to_char('#{params[:end_time]}')"
      action_condition = action_condition + " and  (to_char(to_date(trunc(x.created_at)),'yyyy-mm-dd')) between to_char('#{params[:start_time]}') and to_char('#{params[:end_time]}')"
      action_condition1 = action_condition1 + " and  (to_char(to_date(trunc(bb.created_at)),'yyyy-mm-dd')) between to_char('#{params[:start_time]}') and to_char('#{params[:end_time]}')"
    end
    if !params[:phone_num_info].blank?
      condition = condition + " and ba.target_cellphone in (#{params[:phone_num_info].chop})"
      condition_null = condition_null + " and ba.target_cellphone in (#{params[:phone_num_info].chop})"
      condition2 = condition2 + " and ba.target_cellphone in (#{params[:phone_num_info].chop})"
      condition1 = condition1 + " and a.user_phone in (#{params[:phone_num_info].chop})"
    end

    if !params[:action_type].blank? && params[:action_type].to_i !=-1
      action_condition = action_condition + " and x.action_type= #{params[:action_type]}"
      action_condition1 = action_condition1 + " and bb.action_type= #{params[:action_type]}"
      condition = condition + " and ar.action_type= #{params[:action_type]}"
      if !params[:action_result].blank? && params[:action_result].to_i !=-1 && params[:action_type] !=4
        if params[:action_type].to_i ==2 || params[:action_type].to_i ==3
          action_condition1 = action_condition1 + " and x.action_result= #{params[:action_result]}"
          action_condition = action_condition + " and x.action_result= #{params[:action_result]}"
          condition = condition + " and ar.action_result= #{params[:action_result]}"
          action_condition = action_condition + " and x.action_result = #{params[:action_result]}"
          condition = condition + " and ar.action_result = #{params[:action_result]}"
        else  #type=0,1
          if params[:action_result].to_i==0
            action_condition = action_condition + " and x.action_result = 1" if params[:action_type].to_i ==0
            action_condition = action_condition + " and x.action_result = 3" if params[:action_type].to_i ==1
                action_condition1 = action_condition1 + " and bb.action_result = 1" if params[:action_type].to_i ==0
            condition = condition + " and ar.action_result = 1" if params[:action_type].to_i ==0
            condition = condition + " and ar.action_result = 3" if params[:action_type].to_i ==1
          elsif [1,2,3].include?(params[:action_result].to_i )
            action_condition = action_condition + " and x.action_result = 1 and x.first_book_code=#{params[:action_result]}" if params[:action_type].to_i ==0
            action_condition = action_condition + " and x.action_result = 3 and x.first_book_code=#{params[:action_result]}" if params[:action_type].to_i ==1
             action_condition1 = action_condition1 + " and bb.action_result = 1 and x.first_book_code=#{params[:action_result]}" if params[:action_type].to_i ==0
            action_condition1 = action_condition1 + " and bb.action_result = 3 and x.first_book_code=#{params[:action_result]}" if params[:action_type].to_i ==1
            condition = condition + " and ar.action_result = 1 and ar.first_book_code=#{params[:action_result]}" if params[:action_type].to_i ==0
            condition = condition + " and ar.action_result = 3 and ar.first_book_code=#{params[:action_result]}" if params[:action_type].to_i ==1
          else
            action_condition = action_condition + " and x.action_result=0"   if params[:action_type].to_i ==0
            action_condition = action_condition + " and x.action_result = 2" if params[:action_type].to_i ==1
                        action_condition1 = action_condition1 + " and bb.action_result=0"   if params[:action_type].to_i ==0
            action_condition1 = action_condition1 + " and bb.action_result = 2" if params[:action_type].to_i ==1
            condition = condition + " and ar.action_result=0"   if params[:action_type].to_i ==0
            condition = condition + " and ar.action_result = 2" if params[:action_type].to_i ==1
          end
        end
      end
    end
    if !params[:message_time].blank?
      condition = condition + "and to_char(to_date(trunc(am.created_at)),'yyyy-mm-dd')= '#{params[:message_time]}'"
      condition1 = condition1 + " and  (to_char(to_date(trunc(am.created_at)),'yyyy-mm-dd')) <= '#{params[:message_time]}'"
      message_condition = message_condition +  " and (to_char(to_date(trunc(am1.created_at)),'yyyy-mm-dd'))  = '#{params[:message_time]}'"
      condition2 = condition2 + "and to_char(to_date(trunc(am.created_at)),'yyyy-mm-dd') <= '#{params[:message_time]}'"
    end
    if !params[:message_type_info].blank?
      condition = condition + " and am.message_type in (#{params[:message_type_info].chop})"
      condition2 = condition2 + " and am.message_type in (#{params[:message_type_info].chop})"
      if params[:message_time].blank?
        condition1 = condition1 + " and  (to_char(to_date(trunc(am.created_at)),'yyyy-mm-dd')) <= '#{Date.today.to_s('yyyy-mm-dd')}'"
        message_condition = message_condition +  " and (to_char(to_date(trunc(am1.created_at)),'yyyy-mm-dd'))  = '#{Date.today.to_s('yyyy-mm-dd')}'"
      end
      condition1 = condition1 + " and am.message_type in (#{params[:message_type_info].chop})"
    end
    if !params[:message_count].blank?
      if params[:message_time].blank?
        condition1 = condition1 + " and  (to_char(to_date(trunc(am.created_at)),'yyyy-mm-dd')) <= '#{Date.today.to_s('yyyy-mm-dd')}'"
        message_condition = message_condition +  " and (to_char(to_date(trunc(am1.created_at)),'yyyy-mm-dd'))  = '#{Date.today.to_s('yyyy-mm-dd')}'"
      end
      having = having+ " and  count(1)= #{params[:message_count]}"
    end
      sort = return_sort(params[:sort])
      if params[:message_count].blank? && params[:message_type_info].blank? && params[:message_time].blank?
        if params[:message_time].blank?  && params[:message_type_info].blank?
          sql = "select gd.name area_name,decode(st.s_type,0,'城市',1,'城镇',2,'农村') s_type,gs.name s_name,gg.name||gc.name  class_name,ba.target_cellphone cellphone,uu.display_name display_name, count(ar.user_phone ) r_count from  book_activities ba  left join action_records ar on ba.target_cellphone = ar.user_phone inner join parents p on ba.user_id=p.id left join students s on p.student_id=s.id inner join user_groups gc on s.schoolclass_id=gc.id inner join user_groups gg on gc.parent_id=gg.id  inner join user_groups gs on gg.parent_id=gs.id  inner join user_groups gd on gs.parent_id=gd.id inner join school_types st on gs.id=st.school_id inner join  users uu on ba.user_id = uu.id    where "+condition+" group by gd.name,st.s_type,gs.name,gg.name||gc.name,ba.target_cellphone,uu.display_name order by "+sort
        else
          sql = "select gd.name area_name,decode(st.s_type,0,'城市',1,'城镇',2,'农村') s_type,gs.name s_name,gg.name||gc.name  class_name,ba.target_cellphone cellphone,uu.display_name display_name, count(ar.user_phone ) r_count from  book_activities ba  left join action_records ar on ba.target_cellphone = ar.user_phone inner join parents p on ba.user_id=p.id left join students s on p.student_id=s.id inner join user_groups gc on s.schoolclass_id=gc.id inner join user_groups gg on gc.parent_id=gg.id  inner join user_groups gs on gg.parent_id=gs.id  inner join user_groups gd on gs.parent_id=gd.id inner join school_types st on gs.id=st.school_id inner join  users uu on ba.user_id = uu.id  left join activity_messages am on ba.user_id=am.user_id where "+condition+" group by gd.name,st.s_type,gs.name,gg.name||gc.name,ba.target_cellphone,uu.display_name order by "+sort
        end
      else
        sql = "select  gd.name area_name,decode(st.s_type,0,'城市',1,'城镇',2,'农村') s_type,gs.name s_name,gg.name||gc.name  class_name,a.user_phone cellphone,uu.display_name display_name, ar.r_count r_count,count(1) c from ( select distinct x.user_phone from action_records x  where "+action_condition+"  ) a inner join (select user_phone user_phone,count(*) r_count from action_records  bb where  "+action_condition1+" group by user_phone ) ar on  ar.user_phone=a.user_phone inner join book_activities ba on  ba.target_cellphone = a.user_phone  inner join parents p on ba.user_id=p.id inner join students s on p.student_id=s.id inner join user_groups gc on s.schoolclass_id=gc.id inner join user_groups gg on gc.parent_id=gg.id inner join user_groups gs on gg.parent_id=gs.id inner join user_groups gd on gs.parent_id=gd.id inner join school_types st on gs.id=st.school_id inner join activity_messages am on ba.user_id=am.user_id inner join users uu on ba.user_id = uu.id inner  join (select distinct am1.user_id from activity_messages am1 where "+message_condition+" ) z on  z.user_id=am.user_id where  "+condition1+"   group by gd.name,st.s_type,gs.name,gg.name||gc.name,a.user_phone,uu.display_name, ar.r_count having "+having+" union select  gd.name area_name,decode(st.s_type,0,'城市',1,'城镇',2,'农村') s_type,gs.name s_name,gg.name||gc.name  class_name, ba.target_cellphone  cellphone,uu.display_name display_name,0 r_count,count(1) c from (select distinct am2.user_id from activity_messages am2 where am2.user_id not in (select bac.user_id from book_activities bac where bac.target_cellphone in (select ar2.user_phone from action_records ar2)) ) ar inner join book_activities ba on  ba.user_id=ar.user_id  inner join parents p on ba.user_id=p.id inner join students s on p.student_id=s.id inner join user_groups gc on s.schoolclass_id=gc.id inner join user_groups gg on gc.parent_id=gg.id inner join user_groups gs on gg.parent_id=gs.id inner join user_groups gd on gs.parent_id=gd.id inner join school_types st on gs.id=st.school_id inner join activity_messages am on ba.user_id=am.user_id left join users uu on ba.user_id = uu.id  inner  join (select distinct am1.user_id from activity_messages am1  where "+message_condition+") z on  z.user_id=am.user_id where "+condition2+" group by gd.name,st.s_type,gs.name,gg.name||gc.name, ba.target_cellphone,uu.display_name  having "+having+" order by "+sort
      end
    action_recordes = ActionRecord.find_by_sql(sql)
    e_book = Spreadsheet::Workbook.new
    e_sheet = Spreadsheet::Worksheet.new :name => "a"
    e_sheet.insert_row 0,['用户行为']
    e_sheet.insert_row 2,['地区','学校类型','学校名称','班级','手机号','历史']
    rows =3
    (action_recordes || []).each do |recorde|
      e_sheet.insert_row rows,[recorde.area_name,recorde.s_type,recorde.s_name,recorde.class_name,recorde.cellphone, recorde.r_count]
      rows = rows + 1
    end
    e_book.add_worksheet e_sheet
    e_book.write "#{RAILS_ROOT}/public/data/reports/b2.xls"
    send_file "#{RAILS_ROOT}/public/data/reports/b2.xls"
  end
  private
  def return_sort sort_value
    sort = case  sort_value
    when "history_reverse" then "r_count asc"
    when "history"  then "r_count desc"
    else "r_count desc"
    end
    return sort
  end
end
