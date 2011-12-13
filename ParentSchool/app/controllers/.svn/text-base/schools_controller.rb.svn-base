class SchoolsController < ApplicationController
  layout "default"

  def index
    @region_id = School::REGIONS[:NORMAL]
  end

  def check_region
    @region_id = params[:region_id]
    render :template => "/schools/index"
  end
end
