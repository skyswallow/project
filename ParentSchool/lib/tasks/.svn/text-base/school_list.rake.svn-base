namespace :school_list do
  task(:record => :environment) do
    total = User.find_by_sql("select count(*) parent_count from users u
inner join parents p on p.id=u.id
inner join students stu on stu.id=p.student_id
inner join user_groups gc on gc.id=stu.schoolclass_id
inner join user_groups gg on gg.id=gc.parent_id
inner join user_groups gs on gs.id=gg.parent_id
inner join user_groups gr on gr.id=gs.parent_id
inner join user_groups gt on gt.id=gr.parent_id
where u.user_type='3' and gc.status!='40' and gg.group_category_type!='67' and gg.group_category_type!='68' and gs.status!='40' and gs.id!='6863' and gt.id='9'
and gg.group_category_type in ('21', '22', '23', '24', '25', '26','31', '32', '33','41', '42', '43')
and gs.code not in ('2610','1946','1463','1420','2630','1388','1424','1290','1441','1924','1916','2782','2926')")
    day_count = ((total[0].parent_count/40).to_f).round + 1
    1.upto(40) do |i|
      school_parent_count = User.find_by_sql("select gs.code school_code,gs.name school_name,count(*) parent_count from users u
inner join parents p on p.id=u.id
inner join students stu on stu.id=p.student_id
inner join user_groups gc on gc.id=stu.schoolclass_id
inner join user_groups gg on gg.id=gc.parent_id
inner join user_groups gs on gs.id=gg.parent_id
inner join user_groups gr on gr.id=gs.parent_id
inner join user_groups gt on gt.id=gr.parent_id
where u.user_type='3' and gc.status!='40' and gg.group_category_type!='67' and gg.group_category_type!='68' and gs.status!='40' and gs.id!='6863'
and gt.id='9' and gg.group_category_type in ('21', '22', '23', '24', '25', '26','31', '32', '33','41', '42', '43')
and gs.code not in ('2610','1946','1463','1420','2630','1388','1424','1290','1441','1924','1916','2782','2926')
and u.id not in (select ba.user_id from book_activities ba)
group by gs.code,gs.name order by parent_count")
      result, h_a, num = [], [], 0
      school_parent_count.each do |p|
        h_a << p.school_code.to_i << p.parent_count.to_i
      end
      h = Hash[*h_a]
      h.each do |k, v|
        num += v
        if num <= day_count
          result << "'#{k}'"
        elsif result.size > 0 and num > day_count
          num -= v
          next
        elsif result.size == 0 and v > day_count
          result << "'#{k}'"
          break
        end
      end
      parent_list = User.find_by_sql(["select distinct(u.username) username,u.id user_id,case when gg.group_category_type in ('21', '22', '23', '24', '25', '26') then 0 else 1 end parent_type from users u
inner join parents p on p.id=u.id
inner join students stu on stu.id=p.student_id
inner join user_groups gc on gc.id=stu.schoolclass_id
inner join user_groups gg on gg.id=gc.parent_id
inner join user_groups gs on gs.id=gg.parent_id
where gs.code in (#{result.join(", ")}) and u.user_type='3' and u.status != '40'
and gg.group_category_type in ('21', '22', '23', '24', '25', '26','31', '32', '33','41', '42', '43')"])
      (parent_list || []).each do |parent|
        hash = {
          :user_id => parent.user_id,
          :username => parent.username,
          :status => 0,
          :parent_type => if parent.parent_type == 0
            false
          else
            true
          end,
          :active_date => Date.today + i.to_i.days
        }
        BookActivity.create hash if !BookActivity.find_by_user_id(parent.user_id)
      end
      reports = User.find_by_sql(["select gs.code school_code,gs.name school_name,count(*) parent_count from users u
inner join parents p on p.id=u.id
inner join students stu on stu.id=p.student_id
inner join user_groups gc on gc.id=stu.schoolclass_id
inner join user_groups gg on gg.id=gc.parent_id
inner join user_groups gs on gs.id=gg.parent_id
inner join user_groups gr on gr.id=gs.parent_id
inner join user_groups gt on gt.id=gr.parent_id
where u.user_type='3' and gc.status!='40' and gg.group_category_type!='67' and gg.group_category_type!='68' and gs.status!='40' and gs.id!='6863' and gt.id='9' and gg.group_category_type in ('21', '22', '23', '24', '25', '26','31', '32', '33','41', '42', '43')
and gs.code in (#{result.join(", ")})
group by gs.code,gs.name order by parent_count"])
      file_path = "#{RAILS_ROOT}/public/data/book_activities.txt"
      if File.exists? file_path
        file = File.open( file_path, "a")
      else
        file = File.new( file_path, "w")
      end
      (reports || []).each do |r|
        file.puts r.school_code.to_s + "\t" + r.school_name.to_s + "\t" + r.parent_count.to_i.to_s + "\t" + (Date.today + i.to_i.days).to_s
      end
    end
  end

  task(:import => :environment) do
    parent_list = User.find_by_sql(["select distinct(u.username) username,u.id user_id from users u
inner join parents p on p.id=u.id
inner join students stu on stu.id=p.student_id
inner join user_groups gc on gc.id=stu.schoolclass_id
inner join user_groups gg on gg.id=gc.parent_id
inner join user_groups gs on gs.id=gg.parent_id
where gs.code='1224' and u.user_type='3' and u.status != '40' and gc.status!='40' and gg.group_category_type!='67' and gg.group_category_type!='68' and gs.status!='40' and gs.id!='6863'"])
    (parent_list || []).each do |parent|
      hash = {
        :user_id => parent.user_id,
        :username => parent.username,
        :status => 0,
        :parent_type => true,
        :active_date => Date.today + 2.to_i.days
      }
      BookActivity.create hash if !BookActivity.find_by_user_id(parent.user_id)
    end
  end

  task(:list => :environment) do
    num = Dir.glob(RAILS_ROOT + "/public/data/reports/*.txt").size
    file_path = "#{RAILS_ROOT}/public/data/reports/#{num}.txt"
    if File.exists? file_path
      file = File.open( file_path, "a")
    else
      file = File.new( file_path, "w")
    end
    t = 0
    1.upto(3) do |b|
      users = BookActivity.find :all, :conditions => ["book_code=? and status!=0 and status!=1 and updated_at<?", b, Date.today]
      total = (((Constant::All_BOOKS[b-1][2].to_i)/9).to_f).round + 1
      ids = users.collect(&:id)
      if users and users.size >= total.to_i
        1.upto(total.to_i) do |i|
          ba = BookActivity.find_by_id(ids[rand(ids.length)])
          if ba.status != 1
            ba.status = 1
            ba.updated_at = Date.today
            ba.save
            t += 1
            user = User.find_by_sql(["select gr.name region_name,u.display_name name,u.id user_id from users u
inner join parents p on p.id=u.id
inner join students stu on stu.id=p.student_id
inner join user_groups gc on gc.id=stu.schoolclass_id
inner join user_groups gg on gg.id=gc.parent_id
inner join user_groups gs on gs.id=gg.parent_id
inner join user_groups gr on gr.id=gs.parent_id
inner join user_groups gt on gt.id=gr.parent_id
where u.user_type='3' and u.id=?", ba.user_id])
            file.puts t.to_s + "\t" + user[0].region_name.to_s + "\t" + user[0].name.to_s + "\t" + user[0].user_id.to_s + "\r"
          end
        end
      elsif users and users.size < total.to_i
        1.upto(users.size.to_i) do |i|
          ba = BookActivity.find_by_id(ids[rand(ids.length)])
          if ba.status != 1
            ba.status = 1
            ba.updated_at = Date.today
            ba.save
            t += 1
            user = User.find_by_sql(["select gr.name region_name,u.display_name name,u.id user_id from users u
inner join parents p on p.id=u.id
inner join students stu on stu.id=p.student_id
inner join user_groups gc on gc.id=stu.schoolclass_id
inner join user_groups gg on gg.id=gc.parent_id
inner join user_groups gs on gs.id=gg.parent_id
inner join user_groups gr on gr.id=gs.parent_id
inner join user_groups gt on gt.id=gr.parent_id
where u.user_type='3' and u.id=?", ba.user_id])
            file.puts t.to_s + "\t" + user[0].region_name.to_s + "\t" + user[0].name.to_s + "\t" + user[0].user_id.to_s + "\r"
          end
        end
      end
    end
  end

  desc "award_list by every week"
  task(:award_list => :environment) do
    if 20101101 <= Date.today.strftime("%Y%m%d").to_i and Date.today.strftime("%Y%m%d").to_i <= 20110101
      num = Dir.glob(RAILS_ROOT + "/public/data/week_awards/*.txt").size
      file_path = "#{RAILS_ROOT}/public/data/week_awards/week_#{num}.txt"
      if File.exists? file_path
        file = File.open( file_path, "w")
      else
        file = File.new( file_path, "w")
      end
      file.puts "地区" + "\t" + "家长昵称" + "\t" + "受赠图书" + "\r"

      if Date.today.wday.to_i == 1
        x = 7
      elsif Date.today.wday.to_i == 0
        x = 6
      else
        x = Date.today.wday.to_i - 1
      end
      total = BookActivity.find_by_sql("select gr.name area_name, u.display_name name, bc.book_code
          from book_activities bc
          inner join users u on bc.user_id=u.id
          inner join parents p on p.id=u.id
          inner join students stu on stu.id=p.student_id
          inner join users s on s.id=stu.id
          inner join user_groups gc on gc.id=stu.schoolclass_id
          inner join user_groups gg on gg.id=gc.parent_id
          inner join user_groups gs on gs.id=gg.parent_id
          inner join user_groups gr on gr.id=gs.parent_id
          inner join user_groups gt on gt.id=gr.parent_id
          where bc.status in (1,4,5) and u.user_type=3 and bc.active_date between to_date('#{Date.today - x}','yyyy-mm-dd') and to_date('#{Date.today - 1}','yyyy-mm-dd') order by bc.book_code")

      if total.size > 0
        1.upto(total.size) do |i|
          i -= 1
          book_name = ""
          case
          when total[i].book_code.to_i == 1
            book_name = "《#{Constant::All_BOOKS[0][1]}》"
          when total[i].book_code.to_i == 2
            book_name = "《#{Constant::All_BOOKS[1][1]}》"
          when total[i].book_code.to_i == 3
            book_name = "《#{Constant::All_BOOKS[2][1]}》"
          end
          file.puts total[i].area_name + "\t" + total[i].name + "\t" + book_name + "\r"
        end
      end
      if Date.today.wday.to_i == 1
        unless File.exists? "#{RAILS_ROOT}/public/data/week_awards/week_#{num + 1}.txt"
          new_file = File.new("#{RAILS_ROOT}/public/data/week_awards/week_#{num + 1}.txt", "w")
          new_file.puts "地区" + "\t" + "家长昵称" + "\t" + "受赠图书" + "\r"
        end
      end
    end
  end

  desc "init lottery count every day"
  task(:init_lottery => :environment) do
    ActiveRecord::Base.connection.execute("update book_activities ba set ba.real_count=ba.lottery_count")
  end

  desc "init lottery_settings"
  task(:init_lottery_settings => :environment) do
    dd = Time.mktime(2010,11,1).to_date
    i = 0
    while dd + i < Time.mktime(2011,1,1).to_date do
      i += 1
      LotterySetting.create(:s_count => 26, :b_count => 26, :e_count => 18, :active_date => dd + i) unless LotterySetting.find_by_active_date dd + i
    end
  end

  desc "insert target_cellphone"
  task(:insert_target_cellphone => :environment) do
    BookActivity.transaction do
      p "begin"
      lists = BookActivity.find_by_sql("select ba.*,u.target_cellphone tel_phone from book_activities ba left join users u on u.id=ba.user_id")
      x = 1
      lists.each do |item|
        p "#{item.id}--#{item.tel_phone}---#{x}"
        item.update_attribute(:target_cellphone, item.tel_phone)
        x += 1
      end
      p "end"
    end
  end

  desc "the same username"
  task(:user_code => :environment) do
    sql_str = "select * from (select count(ba.username) num, ba.username from book_activities ba group by ba.username) n where n.num>1"
    lists = BookActivity.find_by_sql(sql_str)
    x = 1
    n = 0
    lists.each do |item|
      users = BookActivity.find_all_by_username item.username, :order => "active_date asc"
      n += (users.length - 1)
      x += 1
      1.upto(users.length) do |i|
        if users[i]
          if users[i].status == 0
            p "user_name:#{users[i].id}--#{x}"
            users[i].destroy
          end
        end
      end
    end
    p "n=#{n}----x=#{x}"
    if x == lists.length + 1
      (BookActivity.find_by_sql(sql_str) || []).each do |ba|
        BookActivity.find_all_by_username(ba.username).each do |b|
          b.destroy if b.status == 0
        end
      end
    end
  end
end