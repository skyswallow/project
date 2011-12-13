class Admin::PageRecordsController < Admin::BaseController
  def index
    @page_recordes = PageRecord.search_page_records_data(params[:sort], params[:search_addr], params[:time],[nil,nil],0, nil)[0].paginate :page => params[:page], :per_page => 20
  end

  def high_search
    @page_recordes = PageRecord.search_page_records_data(params[:sort], params[:search_addr], nil,[params[:start_time],params[:end_time]],1, params[:page] ? params[:page] : 1)[0]
  end

  def page_history
    @page_recordes =  PageRecord.page_history(params[:sort], params[:url]).paginate :page => params[:page], :per_page => 20
  end

  def to_excel
    Page_history.include_spread
    page_records = PageRecord.search_page_records_data(params[:sort], params[:search_addr], params[:time],nil,0, nil)   
    send_file PageRecord.page_records_to_excel(page_records[0], page_records[1])
  end

  def to_excel_high
    Page_history.include_spread
    page_records = PageRecord.search_page_records_data(params[:sort], params[:search_addr], nil,[params[:start_time],params[:end_time]],1, nil)
    send_file PageRecord.page_records_to_excel(page_records[0], page_records[1])
  end
 
  def to_excel_history
    Page_history.include_spread
    page_records =  PageRecord.page_history(params[:sort], params[:url])
    send_file  PageRecord.page_history_to_excel(page_records, params[:url])
  end

end
