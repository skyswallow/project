class Manage::NewsController < ApplicationController
  layout "area"
  before_filter :is_manager
  skip_before_filter :verify_authenticity_token

  def index
    @search_title = nil
    @news = AreaNew.news(cookies[:space_id]).order_by("created_at desc").paginate :per_page => 20, :page => params[:page]
  end

  def show
    @new = AreaNew.find_by_id(params[:id])
    if !@new
      flash[:warn] = "该新闻不存在！"
      redirect_to "/manage/news"
    end
  end

  def create
    if cookies[:space_id]
      AreaNew.create(:area_id => AreaManager.find_by_space_id(cookies[:space_id]).area_id, :news_title => params[:news_title].to_s.strip,
        :news_content => params[:news_content].to_s.strip, :created_by => cookies[:space_id])
      flash[:notice] = "新闻发布成功！"
    end
    redirect_to "/manage/news"
  end

  def destroy
    if cookies[:space_id]
      if AreaNew.find_by_id(params[:id])
        AreaNew.destroy params[:id]
        flash[:notice] = "删除新闻成功！"
      else
        flash[:warn] = "删除新闻失败！"
      end
    end
    redirect_to "/manage/news"
  end

  def search
    @search_title = params[:title].to_s.strip
    if params[:title].nil?
      redirect_to "/manage/news"
    else
      @news = AreaNew.paginate_by_sql(["select n.*,s.nickname from area_news n left join spaces s on s.id=n.created_by
        where n.created_by=? and n.area_id=? and n.news_title like ? order by n.created_at desc", cookies[:space_id],
          AreaManager.find_by_space_id(cookies[:space_id]).area_id, "%#{params[:title].to_s.strip}%"], :page => params[:page], :per_page => 20)
      if @news.size == 0
        flash.now[:warn] = "查询无数据，请检查查询条件是否正确！"
      end
      render :template => "/manage/news/index"
    end
  end

  def edit
    @news = AreaNew.find_by_id(params[:id])
    if !@news
      flash[:warn] = "该新闻不存在!"
      redirect_to "/manage/news"
    end
  end

  def update
    if cookies[:space_id] and params[:id]
      news = AreaNew.find_by_id(params[:id])
      if news
          AreaNew.transaction do
            news.news_title = params[:news_title].strip
            news.news_content = params[:news_content].strip
            news.updated_by = cookies[:space_id]
            if news.save
              flash[:notice] = "该新闻更新成功！"
            end
          end
      else
        flash[:error] = "该新闻更新失败!"
      end
    else
      flash[:error] = "该新闻更新失败!"
    end
    redirect_to "/manage/news"
  rescue
    flash[:error] = "该新闻更新失败!"
    redirect_to "/manage/news"
  end

  private
  def is_manager
    if logged_in?
      if AreaManager.find_by_space_id(cookies[:space_id])
      else
        flash[:warn] = "您无权访问该页面！"
        redirect_to "/"
      end
    else
      flash[:warn] = "您已经退出！"
      redirect_to  "/"
    end
  end

end
