class Admin::LecturesController < Admin::BaseController
  layout "admin"
  require "fileutils"
  require 'rubygems'
  require 'rufus/scheduler'
  def index
    @lectures = Lecture.paginate(:page =>params[:page], :per_page =>20, :order =>"created_at desc")
  end

  def create
    t1 = Time.now
    topic_lecture = Lecture.find_by_topic(params[:lecture][:topic].strip)
    if topic_lecture.nil?
      begin
        lecture = Lecture.create(:topic => params[:lecture][:topic].strip,
          :speaker => params[:lecture][:speaker].strip,
          :target => params[:lecture][:target].strip,
          :created_by => cookies[:space_id],
          :attachment_file_name => params[:lecture][:attachment].original_filename,
          :attachment_file_size => params[:lecture][:attachment].size,
          :attachment_content_type => params[:lecture][:attachment].content_type,
          :lecture_comments_count => 0,
          :photo_url => "/uploads/lectures/attachments")
        if lecture
          flv_name = "#{rand Time.now.to_i}_#{lecture.id}" + "." + params[:lecture][:attachment].original_filename.split('.').reverse[0]
          flv_path = "#{File.expand_path(RAILS_ROOT)}/public/uploads/lectures/attachments/#{lecture.id}/#{flv_name}"
          if !File.exist?(flv_path)
            FileUtils.mkdir_p("#{File.expand_path(RAILS_ROOT)}/public/uploads/lectures/attachments/#{lecture.id}/")
          end
          filename = params[:photo].original_filename.split('.').reverse
          name = "#{rand Time.now.to_i}_#{lecture.id}" + "." + filename[0]
          File.open("#{File.expand_path(RAILS_ROOT)}/public/uploads/editor/#{name}", "wb") do |f|
            f.write(params[:photo].read)
          end
          image=MiniMagick::Image.from_file("#{File.expand_path(RAILS_ROOT)}/public/uploads/editor/#{name}")
          if image[:width]>90 or image[:height]>72
            pic = MiniMagick::Image.new("#{File.expand_path(RAILS_ROOT)}/public/uploads/editor/#{name}")
            pic.resize "90x72>"
            pic.write("#{File.expand_path(RAILS_ROOT)}/public/uploads/lectures/attachments/#{lecture.id}/#{name}")
          else
            File.open("#{File.expand_path(RAILS_ROOT)}/public/uploads/lectures/attachments/#{lecture.id}/#{name}", "wb") do |f|
              f.write(params[:photo].read)
            end
          end
          lecture.update_attribute(:photo_url, "/uploads/lectures/attachments/#{lecture.id}/#{name}")
          scheduler = Rufus::Scheduler.start_new
          scheduler.in("2s") do
            upload_flv_file(flv_path,params[:lecture][:attachment].read,lecture,flv_name)
          end
        end
        puts Time.now.strftime("%Y%m%d%H%M%S"),t1.strftime("%Y%m%d%H%M%S"),(Time.now - t1).to_i
        flash[:notice] = "创建讲座成功！"
        redirect_to admin_lectures_url
      rescue
        lecture.destroy if lecture
        flash[:error] = "创建讲座失败！"
        redirect_to admin_lectures_url
      end
    else
      flash[:error] = "讲座主题有重名！"
      redirect_to request.referrer
    end
  end

  def upload_flv_file(path,data,lecture,flv_name)
    File.open(path, "wb") do |f|
      f.write(data)
    end
    lecture.update_attribute(:attachment_file_name, "/uploads/lectures/attachments/#{lecture.id}/#{flv_name}")
    puts "upload over"
  end

  def destroy
    lecture = Lecture.find_by_id(params[:id])
    if lecture
      FileUtils.remove_dir("#{File.expand_path(RAILS_ROOT)}/public/uploads/lectures/attachments/#{lecture.id}/",true)
      comments = LectureComment.find_all_by_lecture_id lecture.id
      (comments || []).each do |comment|
        comment.destroy if comment
      end
      lecture.destroy
      flash[:notice] = "删除成功！"
    else
      flash[:error] = "该讲座已被删除！"
    end
    redirect_to admin_lectures_url
  end
end