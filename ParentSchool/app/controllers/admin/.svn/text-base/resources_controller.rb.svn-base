class Admin::ResourcesController < Admin::BaseController
  
  def index
    @resources = Resource.find(:all,
      :select => "r.*, s.nickname, rt1.name, rt2.name parent_name",
      :from => "resources r",
      :joins => "left join spaces s on r.created_by = s.id
                 left join resource_types rt1 on r.resource_type = rt1.id
                 left join resource_types rt2 on rt2.id = rt1.parent_id",
      :order => "r.created_at desc").paginate(:page => params[:page], :per_page => 20)
  end

  def select_types
    parent_id = params[:parent_id]
    if parent_id
      if parent_id.to_i == 0
        @rts = nil
      else
        @rts = ResourceType.find_by_parent_id(parent_id).collect{|item|[item.name, item.id]}.insert(0, ["请选择...", 0])
      end
    else
      @rts = [["请选择...", 0]]
    end
    render(:layout => false)
  end

  def create
    resource = Resource.new(params[:resource])
    resource.title = params[:resource][:title].strip
    resource.description = params[:resource][:description].strip unless params[:resource][:description].nil?
    resource.created_by = cookies[:space_id]
    resource.save
    flash[:notice] = "发布成功！"
    redirect_to admin_resources_url
  rescue
    flash[:error] = "发布失败！"
    redirect_to admin_resources_url
  end

  def destroy
    resource = Resource.find_by_id(params[:id])
    if resource
      resource.destroy
      flash[:notice] = "删除成功！"
    else
      flash[:error] = "该资源已被删除！"
    end
    redirect_to admin_resources_url
  rescue
    flash[:error] = "该资源已被删除！"
    redirect_to admin_resources_url
  end

end
