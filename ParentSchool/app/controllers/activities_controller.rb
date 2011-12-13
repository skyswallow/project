class ActivitiesController < ApplicationController
  layout "default", :except => ["show"]

  def index
    @activities = Activity.normal.all_order_by_created_at_desc.paginate(:page => params[:page], :per_page => 5)
  end

  def new
    @activity = Activity.find_by_id(params[:id])
    activity_exist(@activity) do
    end
    redirect_to activities_url if !@activity
  end

  def create
    ActivityApply.create(params[:activity_apply])
    flash[:notice] = "报名成功！"
    redirect_to "/activities/new?id=#{params[:activity_apply][:activity_id]}"
  end

  def show
    @activity = Activity.find_by_id(params[:id])
    activity_exist(@activity) do
    end
    redirect_to activities_url if !@activity
  end

end
