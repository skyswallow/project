class Admin::NewsLinesController < Admin::BaseController
  layout "admin", :except => ["show"]
  def index
    @lines = NewsLine.paginate_by_sql(["select n.*,s.parent_id,t.nickname from news_lines n
            left join news_types s on s.id=n.news_type
            left join spaces t on t.id=n.created_by
            order by n.created_at desc"], :per_page =>30, :page => params[:page])
  end

  def new
    @news_types = [["请选择",""]]+NewsType.find_all_by_parent_id(0).sort { |a,b| a.id.to_i <=> b.id.to_i}.collect { |item| [item.name, item.id] }
  end

  def create
    unless request.get?
      filename = params[:file].original_filename
      if params[:head_image]&&params[:head_image] != ""
        imgname = params[:head_image].original_filename
      end
      gbkfilename = filename.to_gbk #解决乱码
      @dirname = Time.now.strftime("%Y%m%d")
      all_dir = "#{File.expand_path(RAILS_ROOT)}/public/uploads/news/#{@dirname}/"
      FileUtils.makedirs all_dir    #建目录
      File.open("#{all_dir}#{gbkfilename}", "wb+") do |f|
        f.write(params[:file].read)   #写入读到的数据,注意方法为post,权限wb+
      end
      if params[:head_image]&&params[:head_image] != ""
        gbkimgname = imgname.to_gbk
        File.open("#{all_dir}#{gbkimgname}", "wb+") do |f|
          f.write(params[:head_image].read)   #写入读到的数据,注意方法为post,权限wb+
          f.close
        end
      end
      newpath = "public/uploads/news/#{@dirname}/#{filename}"  #数据库存入编码是对的,不用改动
      line = NewsLine.find_by_path(newpath)
      if line
        flash[:warn]="有重名网页,请重新输入！"
      else
        @line = NewsLine.new
        @line.created_by = cookies[:space_id]
        if params[:sub_type] == ''
          if params[:gonggao] == "gonggao"
            @line.news_type = '22'
          else
            @line.news_type = '21'
          end
        else
          @line.news_type = params[:sub_type]
        end
        @line.title = params[:title].to_s.strip
        @line.path = newpath
        if params[:head_image]&&params[:head_image] != ""
          @line.head_image = "/uploads/news/#{@dirname}/#{gbkimgname}"
        end
        @line.summary = params[:content] if params[:content]
        @line.sub_title = params[:subtitle].strip if params[:subtitle]
        @line.status = NewsLine::STATUS[:NEW]
        @line.save
        flash[:notice]="上传ok！"
      end
      redirect_to admin_news_lines_url
    else
      redirect_to admin_news_lines_url
    end
  end

  def edit
    @news_types = [["请选择",""]]+NewsType.find_all_by_parent_id(0).sort { |a,b| a.id.to_i <=> b.id.to_i}.collect { |item| [item.name, item.id] }
    @line = NewsLine.find(params[:id])
    if @line.status == NewsLine::STATUS[:NOMAL]
      flash[:warn]="已发布,不可再修改"
      redirect_to admin_news_lines_url
    end
  end

  def update
    @line = NewsLine.find_by_id(params[:id])
    @gbkfilename = @line.path.to_gbk
    if params[:sub_type] == ''
      if params[:gonggao] == "gonggao"
        @line.news_type = '22'
      else
        @line.news_type = '21'
      end
    else
      @line.news_type = params[:sub_type]
    end
    @line.update_attributes(:news_type => @line.news_type, :summary => "#{@line.summary}  ",
      :updated_by => cookies[:space_id])
    File.open("#{File.expand_path(RAILS_ROOT)}/#{@gbkfilename}", "wb+") do |f|
      f.write(params[:file].read)    #写入读到的数据,注意方法为post,权限wb+
      f.close
    end
    flash[:notice]="上传ok！"
    redirect_to admin_news_lines_url
  end

  def show
    @line = NewsLine.find_by_id(params[:id])
    if @line
      @type = @line.news_type
      @file = "#{@line.path}"
      @gbkfilename =  @file.to_gbk    #解决乱码
      @real_root = "#{File.expand_path(RAILS_ROOT)}/#{@gbkfilename}"
      @if_exist = File.exist?(@real_root)
    else
      flash[:warn] = "新闻不存在！"
      redirect_to admin_news_lines_url
    end
  end

  def release
    @line = NewsLine.find_by_id(params[:id])
    if @line
      if @line.status == NewsLine::STATUS[:NOMAL]
        flash[:warn] = "该新闻已经发布！"
      else
        @line.update_attributes(:status => NewsLine::STATUS[:NOMAL],:summary => "#{@line.summary}  ")
        flash[:notice] = "发布成功！"
      end
    else
      flash[:warn] = "新闻不存在！"
    end
    redirect_to admin_news_lines_url
  end

  def check
    if params[:file]
      basename =  File.basename(params[:file])
      basename = basename.reverse.split("\\")[0].reverse
      @dirname = Time.now.strftime("%Y%m%d")
      path = "public/uploads/news/#{@dirname}/#{basename}"
      line = NewsLine.find_by_path(path)
      if !line.nil? and line != ""
        render :inline => "有重名网页,请重新输入！"
      else
        render :inline => "没有跟已有文件重名"
      end
    end
  end

  def checkimg
    if params[:head_image]
      basename =  File.basename(params[:head_image])
      basename = basename.reverse.split("\\")[0].reverse
      @dirname = Time.now.strftime("%Y%m%d")
      newpath =  "public/uploads/news/#{@dirname}/#{basename}"    #解决乱码
      @real_root = "#{File.expand_path(RAILS_ROOT)}/#{newpath}"
      if File.exist?(@real_root)
        render :inline => "有重名图片,请重新输入！"
      else
        render :inline => "没有跟已有图片重名"
      end
    end
  end

  def select_sub_type
    if params[:parent_id]
      @sub_types = [["请选择",""]]+NewsType.find_all_by_parent_id(params[:parent_id]).sort {|a,b| a.id.to_i <=> b.id.to_i}.collect { |item| [item.name, item.id] }
    end
    render(:layout => false)
  end

  def upload
    filename = params[:file].original_filename
    @dirname = Time.now.strftime("%Y%m%d")
    newpath =  "public/uploads/news/#{@dirname}/#{filename}"
    @real_root = "#{File.expand_path(RAILS_ROOT)}/#{newpath}"
    if File.exist?(@real_root)
      flash[:warn]="有重名图片,请重新输入！"
      redirect_to request.referrer
    else
      all_dir = "#{File.expand_path(RAILS_ROOT)}/public/uploads/news/#{@dirname}/"
      FileUtils.makedirs all_dir    #建目录
      File.open("#{all_dir}#{filename}", "wb+") do |f|
        f.write(params[:file].read)   #写入读到的数据,注意方法为post,权限wb+
        f.close
      end
      flash[:notice]="上传ok！"
      redirect_to admin_news_lines_url
    end
  end

  def recommend
    if params[:id]
      line = NewsLine.find_by_id(params[:id])
      all_recommended_top = NewsLine.find(:all, :conditions =>["is_recommended = ? and news_type = ?",NewsLine::IS_RECOMMENDED[:YES], 21])
      all_recommended = NewsLine.find(:all, :conditions =>["is_recommended = ? and news_type in (?)",NewsLine::IS_RECOMMENDED[:YES],[2,3,4,5]])
      if line.news_type == '21'
        if all_recommended_top.size >= 1
          flash[:warn] = "只能推荐一篇置顶新闻，请取消一篇推荐！"
        else
          line.update_attributes(
            :is_recommended =>NewsLine::IS_RECOMMENDED[:YES],
            :recommended_by =>cookies[:space_id],
            :recommended_at =>Time.now
          )
          flash[:notice] = "新闻推荐成功！"
        end
      else
        unless all_recommended.size >= 6
          if line
            if line.is_recommended == NewsLine::IS_RECOMMENDED[:YES]
              flash[:warn] = "该新闻已被推荐！"
            else
              line.update_attributes(
                :is_recommended =>NewsLine::IS_RECOMMENDED[:YES],
                :recommended_by =>cookies[:space_id],
                :recommended_at =>Time.now
              )
              flash[:notice] = "新闻推荐成功！"
            end
          else
            flash[:error] = "新闻推荐失败！"
          end
        else
          flash[:warn] = "推荐的新闻已经满6篇，请取消已推荐的之后再推荐！"
        end
      end
    else
      flash[:error] = "新闻推荐失败！"
    end
    redirect_to request.referrer
  end

  def cancle_recommend
    if params[:id]
      line = NewsLine.find_by_id(params[:id])
      if line
        if line.is_recommended == NewsLine::IS_RECOMMENDED[:NO]
          flash[:warn] = "该新闻已被取消推荐！"
        else
          line.update_attribute(:is_recommended ,NewsLine::IS_RECOMMENDED[:NO])
          flash[:notice] = "新闻取消推荐成功！"
        end
      else
        flash[:error] = "新闻取消推荐失败！"
      end
    else
      flash[:error] = "新闻取消推荐失败！"
    end
    redirect_to request.referrer
  end
end

class String
  def to_gbk
    Iconv.iconv("GBK//IGNORE","UTF-8//IGNORE",self).to_s
  end
  def to_utf8
    Iconv.iconv("UTF-8//IGNORE","GBK//IGNORE",self).to_s
  end
end

