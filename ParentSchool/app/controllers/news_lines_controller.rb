class NewsLinesController < ApplicationController
  layout "default"

  def news
    t = NewsType.find_all_by_parent_id(1).collect { |e| e.id.to_s }
    y = ""
    (t || []).each do |id|
      y << id + ","
    end
    types = y[0,y.length - 1]
    lines = NewsLine.find_by_sql(["SELECT news_lines.id,news_lines.path,news_lines.summary,news_lines.created_at,news_lines.title,news_lines.head_image,spaces.nickname
      FROM news_lines  left join spaces on spaces.id=news_lines.created_by
      WHERE (news_lines.status=#{NewsLine::STATUS[:NOMAL]} and news_lines.news_type in (#{types}) and news_lines.is_recommended =#{NewsLine::IS_RECOMMENDED[:YES]})
      ORDER BY news_lines.recommended_at desc"])
    lines1 = NewsLine.find_by_sql(["SELECT news_lines.id,news_lines.path,news_lines.summary,news_lines.created_at,news_lines.title,news_lines.head_image,spaces.nickname
      FROM news_lines  left join spaces on spaces.id=news_lines.created_by
      WHERE (news_lines.status=#{NewsLine::STATUS[:NOMAL]} and news_lines.news_type in (#{types}) and news_lines.is_recommended =#{NewsLine::IS_RECOMMENDED[:NO]})
      ORDER BY created_at desc"])
    @lines = (lines + lines1).paginate(:per_page => 5,:page => params[:page])
  end

  def sub_news
    @lines = NewsLine.paginate :all, 
      :select => "news_lines.id,news_lines.path,news_lines.summary,news_lines.created_at,news_lines.title,news_lines.head_image,spaces.nickname",
      :conditions => ["news_lines.status=? and news_lines.news_type=?", NewsLine::STATUS[:NOMAL],params[:id].to_i],
      :joins => "left join spaces on spaces.id=news_lines.created_by",
      :per_page => 5,:page => params[:page], :order => 'created_at desc'
    render :template => "/news_lines/news"
  end

  def month_news
    @lines = NewsLine.paginate :all, 
      :select => "news_lines.id,news_lines.path,news_lines.summary,news_lines.created_at,news_lines.title,news_lines.head_image,spaces.nickname",
      :conditions => ["news_lines.status=? and news_lines.news_type in (?) and to_char(news_lines.created_at,'yyyymm')=?", NewsLine::STATUS[:NOMAL], [2,3,4,5],params[:id]],
      :joins => "left join spaces on spaces.id=news_lines.created_by",
      :per_page => 5,:page => params[:page], :order => 'created_at desc'
    render :template => "/news_lines/news"
  end

  def parent_class
    @index_hash = Hash.new
    @settings = IndexSetting.all
    @settings.each do |setting|
      @index_hash[setting.code] = setting.online_file_path
    end
  end

  def sub_parent_class
    @type =  NewsType.find_by_id(params[:id])
    @lines = NewsLine.paginate :all,
      :select => "news_lines.*,spaces.nickname",
      :joins => "left join spaces on spaces.id=news_lines.created_by",
      :conditions => ["news_lines.status=? and news_lines.news_type=?", NewsLine::STATUS[:NOMAL], params[:id]],
      :per_page => 20,:page => params[:page], :order => 'news_lines.created_at desc'
  end

  def virtue_and_law
    @four_lines = NewsLine.find(:all , :conditions => [ "status = ? and types = ?", NewsLine::STATUS[:NOMAL], NewsLine::TYPES[:morals][:id]],:limit =>4, :order => "created_at desc")
    @lines = NewsLine.paginate( :conditions => [ "status = ? and types = ?", NewsLine::STATUS[:NOMAL], NewsLine::TYPES[:morals][:id]], :page => params[:page], :per_page => 12, :order => "created_at desc")
  end

  def health
    @four_lines = NewsLine.find(:all , :conditions => [ "status = ? and types = ?", NewsLine::STATUS[:NOMAL], NewsLine::TYPES[:health][:id]],:limit =>4, :order => "created_at desc")
    @lines = NewsLine.paginate( :conditions => [ "status = ? and types = ?", NewsLine::STATUS[:NOMAL], NewsLine::TYPES[:health][:id]], :page => params[:page], :per_page => 12, :order => "created_at desc")
  end

  def show
    @line = NewsLine.find(params[:id])
    #    if @line.status == 0
    #      flash[:warn]='文章尚未提交'
    if @line.news_type == "21" && @line.is_recommended != 1
      flash[:warn]='该新闻已被取消推荐！'
      redirect_to '/home'
    else
      @five_lines = NewsLine.find(:all , :conditions => [ "status = ? ", NewsLine::STATUS[:NOMAL]],:limit =>5, :order => "created_at desc")
      @type = @line.news_type
      @file = "#{@line.path}"
      @gbkfilename = @file.to_gbk  #解决乱码
      @real_root = "#{File.expand_path(RAILS_ROOT)}/#{@gbkfilename}"
      @if_exist = File.exist?(@real_root)
    end
  end

  def book
    @index_hash = Hash.new
    @settings = IndexSetting.all
    @settings.each do |setting|
      @index_hash[setting.code] = setting.online_file_path
    end
  end
end

def out_status_news
  statu = NewsLine.find_by_id(params[:id]).is_recommended
  render :update do |page|
    page.replace_html "news_status", statu.to_i
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
