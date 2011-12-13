class Admin::NoticesController < Admin::BaseController
  layout "admin"
  def index
    @notices = Notice.paginate(:page =>params[:page], :per_page =>20, :order =>"created_at desc")
  end

  def create
    Notice.create(:title =>params[:n_title].strip, :content =>params[:n_content].strip,:space_id =>cookies[:space_id])
    flash[:notice] = "发布成功！"
    redirect_to "/admin/notices"
  end

  def preview
    render :update do |page|
      page.replace_html "n_layer1", :partial => "/admin/notices/preview"
    end
  end

  def show
    @notice = Notice.find params[:id]
    render :update do |page|
      page.replace_html "n_layer",:partial => "notice_html"
    end
  rescue
    render :update do |page|
      page.replace_html "n_layer",:partial => "notice_html"
    end
  end

  def destroy
    notice = Notice.find_by_id(params[:id])
    if notice
      notice.destroy
      flash[:notice] = "删除成功！"
    else
      flash[:error] = "该公告已被删除！"
    end
    redirect_to admin_notices_url
  end
end
