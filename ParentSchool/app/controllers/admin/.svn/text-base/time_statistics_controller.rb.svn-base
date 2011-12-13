class Admin::TimeStatisticsController < Admin::BaseController
  def index    
    @i =  params[:find_date].blank? ? 0 : params[:find_date]    
    @time_date  = PageRecord.time_statistics(params[:sort], params[:url], params[:find_date])
    @time_statistics = PageRecord.time_duan(params[:sort], @time_date)
  end
  
  def show
    @time_date  = PageRecord.time_statistics_high(params[:url], params[:sort], params[:start_time], params[:end_time])
    @time_statistics = PageRecord.time_duan(params[:sort], @time_date)
  end

  def create
    unless params[:id].blank?
      @total_xls = PageRecord.time_statistics_high(params[:url], params[:sort], params[:start_time], params[:end_time])
    else
      @total_xls = PageRecord.time_statistics(params[:sort], params[:url], params[:find_date])
    end
    send_file PageRecord.to_time_xls(params[:sort], params[:id], params[:url], params[:start_time], params[:end_time], params[:find_date], @total_xls)
  end
end
