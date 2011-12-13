# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Constant, Roles

  def use_validate_js_tooltip
    html = javascript_include_tag "validation_cn"
    html += javascript_include_tag "tooltips"
    html += javascript_include_tag "prototip"
    html += stylesheet_link_tag "validates/tooltips.css"
    html
  end



  def is_admin?
    if logged_in?
      if Constant::HOME_ADMINS.include?(cookies[:passport])
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def is_area_admin?
    if logged_in?
      if AreaManager.find_by_space_id(cookies[:space_id])
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def use_css
    html = stylesheet_link_tag "default/ntjxw.css"
    html += stylesheet_link_tag "default/ntjxw_ie6.css"
    html += stylesheet_link_tag "default/ntjxw_ie7.css"
    html += stylesheet_link_tag "default/ntjxw_ie8.css"
    html
  end

  def get_user_school(space_id)
    school = []
    o_school = Group.find_by_sql("select distinct ug2.name name,ug2.id id from groups g left join user_groups ug on g.user_group_id=ug.id left join user_groups ug1 on ug1.id=ug.parent_id left join user_groups ug2 on ug2.id=ug1.parent_id where (g.id in (select gm.group_id from group_members gm
    where gm.space_id='#{space_id}' and gm.is_current_class =1) or g.initiator_id = '#{space_id}') and g.user_group_id is not null and ug1.group_category_type != '67'")
    teacher_school = Group.find_by_sql("select distinct ug.name name,ug.id id from user_groups ug left join teachers t on t.school_id=ug.id left join users u on u.id=t.id left join spaces s on s.user_id=u.person_id where s.id='#{space_id}' and u.user_type=1")
    @school = school.concat(o_school).concat(teacher_school).uniq
  end

  def get_user_school_info(space_id)
    school = []
    o_school = Group.find_by_sql("select distinct ug2.name school_name,ug1.name grade_name,ug.name class_name,ug.id class_id from groups g inner join user_groups ug on g.user_group_id=ug.id inner join user_groups ug1 on ug1.id=ug.parent_id inner join user_groups ug2 on ug2.id=ug1.parent_id where (g.id in (select gm.group_id from group_members gm
    where gm.space_id='#{space_id}' and gm.is_current_class =1) or g.initiator_id = '#{space_id}') and g.user_group_id is not null and ug1.group_category_type != '67' and ug1.group_category_type != '68' order by ug2.name,ug1.name,ug.name")
    teacher_school = Group.find_by_sql("select distinct ug.name school_name,ug1.name grade_name,ug2.name class_name,ug2.id class_id from user_groups ug inner join teachers t on t.school_id=ug.id inner join users u on u.id=t.id inner join spaces s on s.user_id=u.person_id
    inner join user_groups ug1 on ug1.parent_id=ug.id inner join user_groups ug2 on ug2.parent_id=ug1.id where s.id='#{space_id}' and u.user_type=1 and ug1.group_category_type != '67' and ug1.group_category_type != '68' order by ug.name,ug1.name,ug2.name")
    @school_info = school.concat(o_school).concat(teacher_school)
  end

  def get_point(space_id)
    UserActivityRelation.find_by_user_id_and_activity_id(space_id, 2).point rescue 0
  end

  def get_nickname(space_id)
    Space.find_by_id(space_id).nickname rescue ""
  end

  def get_unread_message_count(space_id)
    Message.unread(space_id).size rescue 0
  end

  def is_admin?
    if logged_in?
      if Constant::HOME_ADMINS.include?(cookies[:passport])
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def display_flash
    flash_levels = [:error, :warn, :notice]
    level = flash_levels.find { |flash_level| flash.has_key?(flash_level) }
    level ? "<div id='flash_#{level}' class='flash_#{level}'>" +
      "<span title='关闭' style='float:right;cursor:pointer;' onclick=\"$('flash_#{level}').remove()\">" +
      "<img src='/images/small-close.gif'/>" +
      "</span>" +
      "<img align='absmiddle' src='/images/icon_#{level}.gif' style='margin-right:8px;'/>#{flash[level]}</div>" +
      "<script type='text/javascript' language='javascript'>new Effect.Highlight('flash_#{level}');</script>" : nil
  end

  def re_h(html)
    return "" if html.blank?
    html.to_s.gsub("&amp;","&").gsub("&quot;","\"" ).gsub("&gt;",">").gsub("&lt;","<" )
  end

  # 中英文混合字符串截取
  def truncate_u(text, length = 30, truncate_string = "......")
    l=0
    char_array=text.unpack("U*")
    char_array.each_with_index do |c,i|
      l = l+ (c<127 ? 0.5 : 1)
      if l>=length
        return char_array[0..i].pack("U*")+(i<char_array.length-1 ? truncate_string : "")
      end
    end
    return text
  end

  def partial_tr(name_ary, hidden_value_ary, num = nil, pic_ary = nil)
    tr = ""
    tr += "<table border='1'>"
    (1..name_ary.size).each do |i|
      tr += "<tr>"
      tr += "<td style='padding-top:5px;padding-right:4px;'>#{name_ary[i-1]}</td>"
      tr += "<td><input type='file' name='html#{i}' id='html#{i}' class='validate-file-rhtml' onkeydown='return false' onkeyup='return false' contenteditable='false' /></td>"
      tr += "<td><input type='hidden' name='code#{i}' id='code#{i}' value='#{hidden_value_ary[i-1]}'></td>"
      tr += "</tr>"
    end
    if num && pic_ary
      tr += "<tr>"
      tr += "<td style='padding-top:20px;padding-right:4px;'></td>"
      tr += "</tr>"
      (1..num).each do |j|
        tr += "<tr>"
        tr += "<td style='padding-top:5px;padding-right:4px;'>图片#{j}</td>"
        tr += "<td><input type='file' name='picture#{j}' id='picture#{j}' class='validate-file-jpg-bmp-png-gif' onkeydown='return false' onkeyup='return false' contenteditable='false' /></td>"
        tr += "<td><select id='picture_code#{j}' name='picture_code#{j}'>"
        (0...pic_ary.length).each do |k|
          tr += "<option value='#{pic_ary[k]}'>#{pic_ary[k+1]}</option>" if k % 2 == 0
        end
        tr += "</select></td>"
        tr += "</tr>"
      end
    end
    tr += "</table>"
    tr
  end
  
  def people(region_id,school_type)
    @people = School.find_all_by_region_and_school_type(region_id,school_type,:order => 'name')
  end

  def award_list(date1, date2)
    sql = "select tt.area_name area_name, tt.name name, tt.book_code from (select gr.name area_name, u.display_name name, bc.book_code
          from book_activities bc
          inner join users u on bc.user_id=u.id
          inner join parents p on p.id=u.id
          inner join students stu on stu.id=p.student_id
          inner join users s on s.id=stu.id
          inner join user_groups gc on gc.id=stu.schoolclass_id and gc.group_type=4
          inner join user_groups gg on gg.id=gc.parent_id and gg.group_type=5
          inner join user_groups gs on gs.id=gg.parent_id and gs.group_type=6
          inner join user_groups gr on gr.id=gs.parent_id
          inner join user_groups gt on gt.id=gr.parent_id
          where bc.status in (1,5) and u.user_type=3 and bc.active_date between to_date('#{date1}','yyyy-mm-dd') and to_date('#{date2}','yyyy-mm-dd')
      union
      select gr.name area_name, u.display_name name, bc.book_code
          from book_activities bc
          inner join users u on bc.user_id=u.id
          inner join parents p on p.id=u.id
          inner join students stu on stu.id=p.student_id
          inner join users s on s.id=stu.id
          inner join user_groups gc on gc.id=stu.schoolclass_id and gc.group_type=4
          inner join user_groups gg on gg.id=gc.parent_id and gg.group_type=5
          inner join user_groups gs on gs.id=gg.parent_id and gs.group_type=6
          inner join user_groups gr on gr.id=gs.parent_id
          inner join user_groups gt on gt.id=gr.parent_id
          inner join lottery_records lr on lr.user_id=bc.user_id and lr.is_award = 1
          where bc.status = 4 and u.user_type=3 and to_char(lr.created_at,'yyyymmdd') between to_char(to_date('#{date1}','yyyy-mm-dd'),'yyyymmdd') and to_char(to_date('#{date2}','yyyy-mm-dd'),'yyyymmdd')
      union
      select gr.name area_name, u.display_name name, bc.book_code
          from book_activity_awards bc
          inner join users u on bc.user_id=u.id
          inner join parents p on p.id=u.id
          inner join students stu on stu.id=p.student_id
          inner join users s on s.id=stu.id
          inner join user_groups gc on gc.id=stu.schoolclass_id and gc.group_type=4
          inner join user_groups gg on gg.id=gc.parent_id and gg.group_type=5
          inner join user_groups gs on gs.id=gg.parent_id and gs.group_type=6
          inner join user_groups gr on gr.id=gs.parent_id
          inner join user_groups gt on gt.id=gr.parent_id
          where bc.status in (1,5) and u.user_type=3 and bc.active_date between to_date('#{date1}','yyyy-mm-dd') and to_date('#{date2}','yyyy-mm-dd')
      union
      select gr.name area_name, u.display_name name, bc.book_code
          from book_activity_awards bc
          inner join users u on bc.user_id=u.id
          inner join parents p on p.id=u.id
          inner join students stu on stu.id=p.student_id
          inner join users s on s.id=stu.id
          inner join user_groups gc on gc.id=stu.schoolclass_id and gc.group_type=4
          inner join user_groups gg on gg.id=gc.parent_id and gg.group_type=5
          inner join user_groups gs on gs.id=gg.parent_id and gs.group_type=6
          inner join user_groups gr on gr.id=gs.parent_id
          inner join user_groups gt on gt.id=gr.parent_id
          inner join lottery_records lr on lr.user_id=bc.user_id and lr.is_award = 1
          where bc.status = 4 and u.user_type=3 and to_char(lr.created_at,'yyyymmdd') between to_char(to_date('#{date1}','yyyy-mm-dd'),'yyyymmdd') and to_char(to_date('#{date2}','yyyy-mm-dd'),'yyyymmdd')) tt order by tt.book_code
    "
    BookActivity.find_by_sql(sql)
  end

  def will_paginate_remote(paginator, options={})
    update = options.delete(:update)
    url = options.delete(:url)
    str = will_paginate(paginator, options)
    if str != nil
      str.gsub(/href="(.*?)"/) do
        "href=\"#\" onclick=\"new Ajax.Updater('" + update + "', '" + (url ? url + $1.sub(/[^\?]*/, '') : $1) +
          "', {asynchronous:true, evalScripts:true, method:'get'}); return false;\""
      end
    end
  end

  def sort_link_helper(text, param)
    key = param
    key += "_reverse" if params[:sort] == param
    options = {
      :url => {:action => 'list',:params => params.merge({:sort => key, :page => nil})}
    }
    html_options = {
      :title => "Sort by this "+text,
      :href => url_for(:action => 'list', :params => params.merge({:sort => key, :page => nil}))
    }
    link_to(text, options, html_options)
  end

  def is_apply
   UserActivityRelation.is_apply(cookies[:space_id])
  end
end
