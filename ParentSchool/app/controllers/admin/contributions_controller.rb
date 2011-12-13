class Admin::ContributionsController < Admin::BaseController
  layout "admin"
  def index
    if (params[:link] != nil and params[:link].to_i == 0) or session[:select_type].nil?
      @type = Contribution::STATUS[:APPLY]
    else
      @type = session[:select_type]
    end
    if @type == "-1"
      @conditions = [""]
    else
      @conditions = ["c.status = ?", @type]
    end
    @contributions = Contribution.find(:all,
      :from =>"contributions c",
      :select =>"s.nickname,u.name,c.title,c.created_at,c.status,c.id",
      :joins =>"inner join user_groups u on u.id = c.school_id inner join spaces s on s.id=c.space_id",
      :order => "c.created_at desc",
      :conditions => @conditions).paginate(:page =>params[:page], :per_page =>20, :order =>"created_at desc")
  end

  def show
    if params[:id]
      @contribution = Contribution.find_by_id(params[:id])
      if @contribution.nil?
        flash[:error] = "该篇校园新闻投稿不存在或已删除！"
        redirect_to admin_contributions_url
      end
    end    
  rescue
    flash[:error] = "操作失败！"
    redirect_to admin_contributions_url
  end

  def download
    if params[:id]
      contribution = Contribution.find_by_id(params[:id])
      if contribution
        send_file File.expand_path(RAILS_ROOT) + "/public/" + contribution.attach_path
      else
        flash[:error] = "该篇校园新闻投稿不存在或已删除！"
        redirect_to admin_contributions_url
      end
    end
  rescue
    flash[:error] = "该篇校园新闻投稿附件不存在或已删除！"
    redirect_to request.referrer
  end

  def set_undo
    if params[:id]
      con = Contribution.find_by_id params[:id]
      if con
        if con.status == Contribution::STATUS[:APPLY]
          con.update_attribute(:status, Contribution::STATUS[:UNDO])
          flash[:notice] = "操作成功！"
        else
          flash[:error] = "操作失败！"
        end
      else
        flash[:error] = "操作失败！"
      end
    else
      flash[:error] = "操作失败！"
    end
    redirect_to admin_contributions_url
  end

  def set_do
    if params[:id]
      con = Contribution.find_by_id params[:id]
      if con
        if con.status == Contribution::STATUS[:APPLY]
          con.update_attribute(:status, Contribution::STATUS[:DO])
          flash[:notice] = "操作成功！"
        else
          flash[:error] = "操作失败！"
        end
      else
        flash[:error] = "操作失败！"
      end
    else
      flash[:error] = "操作失败！"
    end
    redirect_to admin_contributions_url
  end

  def select_type
    session[:select_type] = params[:status] unless params[:status].nil?
    redirect_to admin_contributions_url
  end
end
