class Admin::ActivityUsersController < Admin::BaseController
  require 'spreadsheet'

  def index
    @activity_users = ActivityApply.all_by_activity_id(params[:id]).order_by_created_at_desc.paginate(:page => params[:page], :per_page => 20)
    @activity = Activity.find_by_id(params[:id])
    if !@activity_users.empty?
      url = "#{RAILS_ROOT}"
      upload_url = "/uploads/activity_users/#{Time.now.strftime("%Y%m%d%H%M%S")}.xls"
      file_url = url + "/public" + upload_url
      @down_url = "http://#{request.server_name}" + upload_url
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => "#{@activity.name}报名名单"
      sheet.row(0).concat %w{姓名 学校 年级 班级 手机号码 Email}
      r = 1
      ActivityApply.all_by_activity_id(@activity.id).order_by_created_at_desc.each do |user|
        sheet.row(r).push user.name.to_s.strip, user.school.to_s.strip, user.grade.to_s.strip, user.user_class.to_s.strip, user.contact_number.to_s.strip, user.contact_email.to_s.strip
        r += 1
      end
      format = Spreadsheet::Format.new :color => :blue, :weight => :bold,  :size => 14, :align =>:center
      sheet.row(0).default_format = format
      book.write file_url
    end
  end

end
