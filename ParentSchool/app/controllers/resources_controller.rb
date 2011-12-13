class ResourcesController < ApplicationController
  layout "default"

  def index
    if cookies[:space_id]
      space = Space.find_by_id(cookies[:space_id])
      if space.user_id.nil? and Constant::HOME_ADMINS.include?(cookies[:passport]) == false
        flash[:warn] = "您还未绑定，不能下载本站资料，如需下载资料请先<a href='#{CONFIG[:xuexi6_url]}/community/check_jxt_user' target='_blank' style='text-decoration: underline;'><b>绑定</b></a>"
        redirect_to "/"
      end
    else
      flash[:warn] = "您未登陆，请先登录！"
      redirect_to "/"
    end
  end

  def types
    type_id = params[:id].to_i
    if type_id == 0
      @resources = nil
    else
      @resources = Resource.find_by_type(type_id, 10)
    end
    render(:layout => false)
  end

  def show
    @resource = Resource.find_by_id(params[:id])
    render :update do |page|
      page.replace_html  'p_layer', :partial => '/resources/info_html'
    end
  rescue
    render :update do |page|
      page.replace_html  'p_layer', :partial => '/resources/info_html'
    end
  end

  def download
    if !params[:id].nil?
      resource = Resource.find(params[:id])
      if resource
        send_file File.expand_path(RAILS_ROOT) + "/public" + resource.attachment.url
        resource.downloads += 1
        resource.save(false) # 更新下载次数
      else
        flash[:warn] = "该资源已被删除！"
        redirect_to "/"
      end
    else
      flash[:warn] = "该资源已被删除！"
      redirect_to "/"
    end
  rescue
    flash[:warn] = "该资源已被删除！"
    redirect_to "/"
  end

  def search
    if cookies[:space_id].nil?
      flash[:warn] = "您未登陆，请先登录！"
      redirect_to "/"
    else
      @parent_name = ResourceType.find_parent_name(params[:type])
      if @parent_name and @parent_name != ""
        @resources = []
        sql = "select r.*, rt.name from resources r left join resource_types rt on r.resource_type = rt.id where rt.parent_id = '#{params[:type]}'"
        if params[:title] and params[:title] != ""
          sql += " and r.title like '%#{params[:title].strip}%'"
        end
        if params[:sub_type]
          sql += " and r.resource_type = '#{params[:sub_type].to_i}'" unless params[:sub_type].to_i == 0
        end
        sql = sql + " order by r.created_at desc"
        @resources = Resource.paginate_by_sql(sql, :per_page => 20, :page => params[:page])
        if @resources.size == 0
          flash.now[:warn] ="查询无数据，请检查查询条件是否正确！"
        end
      else
        flash[:warn] = "您访问的页面不存在！"
        redirect_to "/resources"
      end
    end
  rescue
    flash[:warn] = "您访问的页面不存在！"
    redirect_to "/resources"
  end
  
end