class AreasController < ApplicationController
  layout "area"

  def index
    @area_id = nil
    unless params[:area_id].nil?
      @area_id = params[:area_id]
      @type = 0
      @news_count = AreaNew.count_by_sql("select count(*) from (select n.*,s.nickname from area_news n inner join spaces s on s.id=n.created_by where n.area_id = #{params[:area_id]} order by n.created_at desc)")
      if @news_count == (params[:page].to_i - 1) * 20 and params[:page].to_i >= 2
        page = params[:page].to_i - 1
        params[:page] = page
        redirect_to "/areas?area_id=#{params[:area_id]}&page=#{page}"
      end
      @area_news_ids = AreaNew.paginate_by_sql(["select n.*,s.nickname from area_news n inner join spaces s on s.id=n.created_by where n.area_id = #{params[:area_id]} order by n.created_at desc"], :page => params[:page], :per_page => 20)
    end
    public_info
  end

  def result
    public_info
    news_title = params[:news_title].strip
    @area_id = params[:area]
    sql = "select an.*,s.nickname from area_news an inner join spaces s on s.id=an.created_by "
    if @area_id.to_i > 0 and @area_id.to_i < 10
      sql += " where an.area_id = #{@area_id}"
    else
      sql += " where an.area_id is not null"
    end
    if news_title and news_title != "请输入新闻标题..."
      sql += " and an.news_title like '%#{news_title}%'"
    end
    puts sql
    @type = params[:type] if params[:type]
    @news_count = AreaNew.find_by_sql(sql)
    if (@news_count and @news_count.size == (params[:page].to_i - 1) * 20) and params[:page].to_i >= 2
      page = params[:page].to_i - 1
      params[:page] = page
    end
    @area_news_ids = AreaNew.paginate_by_sql(sql + " order by an.created_at desc", :page => params[:page], :per_page => 20)
    if @area_news_ids.blank?
      flash[:warn] = "查询无数据，请检查查询条件是否正确！"
      redirect_to areas_url
    end
  end

  def show
    public_info
    if params[:id]
      @news = AreaNew.find_by_id(params[:id])
      if @news.nil?
        flash[:warn] = "该新闻不存在！"
        redirect_to areas_url
      else
        @news.readings += 1
        @news.save
      end
    else
      flash[:warn] = "该新闻不存在！"
      redirect_to request.referrer
    end
  end

  def public_info
    @index_hash = Hash.new
    @settings = IndexSetting.all
    @settings.each do |setting|
      @index_hash[setting.code] = setting.online_file_path if setting.online_file_path
    end
    @read_list = AreaNew.find_by_sql("select * from (select * from area_news n  order by n.readings desc) where rownum <= 10")
  end
end
