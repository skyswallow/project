class Admin::ChangePartialsController < Admin::BaseController
  layout "admin"
  
  def create
    if params[:operate_type] == "0"
      clear_temp_path
    end
    %w{1 2 3 4 5}.each do |i|
      unless params["html" + i].blank?
        filename = params["html" + i].original_filename.split('.').reverse
        @filename = filename[1].split("_")[1] + Time.now.strftime('%Y%m%d%H%M%S') + Time.now.tv_usec.to_s + "." + filename[0]
        IndexSetting.transaction do
          if params[:operate_type] == "0"
            File.open("#{File.expand_path(RAILS_ROOT)}/public" + "#{Constant::TEMP_FILE_PATH}/_" + "#{@filename}", "wb") do |f|
              f.write(params["html" + i].read)
            end
            IndexSetting.find_by_code(params["code" + i]).update_attributes(:temp_file_path => "public" + "#{Constant::TEMP_FILE_PATH}/#{@filename}", :is_online => IndexSetting::IS_ONLINE[:FALSE])
          elsif params[:operate_type] == "1"
            File.open("#{File.expand_path(RAILS_ROOT)}/public" + "#{Constant::ONLINE_FILE_PATH}/_" + "#{@filename}", "wb") do |f|
              f.write(params["html" + i].read)
            end
            online_file_path = "public" + "#{Constant::ONLINE_FILE_PATH}/#{@filename}"
            IndexSetting.find_by_code(params["code" + i]).update_attributes(:temp_file_path => "", :online_file_path => online_file_path, :is_online => IndexSetting::IS_ONLINE[:TRUE])
          end
        end
      end
    end
    picture_upload
    if params[:operate_type] == "1"
      if request.parameters.to_s.include?("#")
        flash[:notice] = "发布成功！"
      else
        flash[:admin_warn] = "请上传需要发布的文件！"
      end
      render :inline => "<script>parent.location.reload();</script>"
    elsif params[:operate_type] == "0"
      case params[:page]
      when "index"
        id = "index"
      when "class"
        id = "class"
      when "exam"
        id = "exam"
      when "parent"
        id = "parent"
      when "blog"
        id = "blog"
      when "book"
        id = "book"
      when "school"
        id = "school"
      end
      render :inline => "<script>window.open('/admin/change_partials/index_preview?id=#{id}','','height=800, width=1000, top=30, left=200, toolbar=no, menubar=no, scrollbars=yes,resizable=no,location=no, status=no');</script>" and return
    end
  end

  def index_preview
    @index_hash = Hash.new
    @settings = IndexSetting.all
    @settings.each do |setting|
      @index_hash[setting.code] = setting.temp_file_path ? setting.temp_file_path : setting.online_file_path
    end
    @read_list = AreaNew.find_by_sql("select * from (select * from area_news n  order by n.readings desc) where rownum <= 10")
    if params[:id] == "school"
      render :layout => "area"
    else
      render :layout => "default"
    end
  end

  private
  def picture_upload
    for i in (1..5)
      j = i.to_s
      unless params["picture" + j].blank?
        file = params["picture" + j]
        index_picture = IndexSetting.find_by_code(params["picture_code" + j])
        if index_picture
          filename = file.original_filename.split('.').reverse
          @filename = Time.now.strftime("%Y%m%d%H%M%S") + Time.now.tv_usec.to_s + params["picture_code" + j] + '.' + filename[0]
          IndexSetting.transaction do
            if params[:operate_type] == "0"
              index_picture.temp_file_path = Constant::PICTURE_TEMP_FILE_PATH + "/#{@filename}"
              index_picture.is_online = IndexSetting::IS_ONLINE[:FALSE]
              file_path = "#{File.expand_path(RAILS_ROOT)}/public" + Constant::PICTURE_TEMP_FILE_PATH + "/#{@filename}"
            else params[:operate_type] == "1"
              file_path = "#{File.expand_path(RAILS_ROOT)}/public" + Constant::PICTURE_ONLINE_FILE_PATH + "/#{@filename}"
              index_picture.temp_file_path = ""
              index_picture.online_file_path = Constant::PICTURE_ONLINE_FILE_PATH + "/#{@filename}"
              index_picture.is_online = IndexSetting::IS_ONLINE[:TRUE]
            end
            File.open(file_path, "wb") do |f|
              f.write(file.read)
            end
            index_picture.save
          end
        end
      end
    end
  end

  def clear_temp_path
    @all_temp_paths = IndexSetting.find(:all, :conditions => "temp_file_path is not null")
    if @all_temp_paths and !@all_temp_paths.blank?
      for temp_path in @all_temp_paths
        temp_path.temp_file_path = ""
        temp_path.save
      end
    end
  end
  
end
