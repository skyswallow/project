class Admin::ActivitiesController < Admin::BaseController

  def index
    @activities = Activity.normal.all_order_by_created_at_desc.paginate(:page => params[:page], :per_page => 20)
  end

  def preview
    if !params[:id].blank?
      @activity = Activity.find_by_id(params[:id])
    else
      @activity = Activity.first :conditions => ["status = '0'"], :order => "created_at desc"
    end
    render :layout => false
  end

  def create
    photos, path = [], "/uploads/activities/"
    [params[:photo], params[:top_photo], params[:bottom_photo]].each do |photo|
      photos << Activity.upload_activity_photo(photo)
    end
    status = params[:operate_type] == "0" ? 0 : 1
    activity_hash = {
      :name => params[:name].to_s.strip, :summary => params[:summary].to_s.strip, :content => params[:content].to_s.strip,
      :start_date => params[:start_date], :end_date => params[:end_date], :photo => path + photos[0],
      :top_photo => path + photos[1], :bottom_photo => path + photos[2], :activity_applies_count => 0, :status => status, :created_by => cookies[:space_id]
    }
    activity = Activity.find_by_name(params[:name].to_s.strip)
    if !activity
      Activity.create(activity_hash)
    else
      activity.update_attributes(activity_hash)
    end
    flash[:notice] = "活动创建成功！" if status == 1
    if params[:operate_type] == "0"
      render :inline => "<script>window.open('/admin/activities/preview', '', 'height=800, width=1000, top=30, left=200, scrollbars=yes,location=yes, status=yes,resizable=no');</script>"
    else
      render :inline => "<script>parent.location.href='/admin/activities';</script>"
    end
  end

  def edit
    @activity = Activity.find_by_id(params[:id])
    activity_exist(@activity) do     
    end
    redirect_to admin_activities_url if !@activity
  end

  def update
    photos, path = [], "/uploads/activities/"
    ([params[:photo], params[:top_photo], params[:bottom_photo]] || []).each do |photo|
      photos << Activity.upload_activity_photo(photo)
    end
    activity = Activity.find_by_id(params[:id])
    status = params[:operate_type] == "0" ? 0 : 1
    activity_exist(activity) do |act|
      (["name", "summary", "content", "start_date", "end_date"] || []).each do |attr|
        act.send(attr + "=", params["#{attr}".to_sym].to_s.strip)
      end
      (["photo", "top_photo", "bottom_photo"] || []).each_with_index do |photo_attr, idx|
        act.send(photo_attr + "=", path + photos[idx]) if !params["#{photo_attr}".to_sym].blank?
      end
      act.updated_by = cookies[:space_id]
      act.save!
      flash[:notice] = "活动修改成功！" if status == 1
    end
    if params[:operate_type] == "0"
      render :inline => "<script>window.open('/admin/activities/preview?id=#{activity.id}', '', 'height=800, width=1000, top=30, left=200, scrollbars=yes,location=yes, status=yes,resizable=no');</script>"
    else
      render :inline => "<script>parent.location.href='/admin/activities';</script>"
    end
  end

  def destroy
    activity = Activity.find_by_id(params[:id])
    activity_exist(activity) do |act|
      Activity.destroy act
      flash[:notice] = "活动删除成功！"
    end
    redirect_to admin_activities_url
  end

end
