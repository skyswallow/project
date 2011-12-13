class Admin::IncomingPagesController < Admin::BaseController
 
  def index    
    @i =  params[:find_date].blank? ? 0 : params[:find_date]     
    @incomming_history = PageRecord.incomming_history(params['sort'], params[:url], params[:find_date], params[:find_url]).paginate :page => params[:page], :per_page => 20
  end
  
  def show   
    @incomming_history = PageRecord.incomming_high(params[:url], params[:start_time], params[:end_time], params[:find_url], params['sort']).paginate :page => params[:page], :per_page => 20
  end

  def create    
    unless params[:id].blank?
      @total_xls = PageRecord.incomming_high(params[:url], params[:start_time], params[:end_time], params[:find_url], params['sort'])
    else
      @total_xls = PageRecord.incomming_history(params['sort'], params[:url], params[:find_date], params[:find_url])
    end
    send_file PageRecord.to_incoming_xls(params[:id], params[:url], params[:start_time], params[:end_time], params[:find_date], @total_xls, params[:find_url].to_i)
  end
end
