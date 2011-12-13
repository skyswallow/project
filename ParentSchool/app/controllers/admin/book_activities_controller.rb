class Admin::BookActivitiesController < Admin::BaseController

  def create
    0.upto(2) do |i|
      ba = BookSetting.find :first, :conditions => ["book_code = ? and created_at = ?", Constant::All_BOOKS[i][0], Date.today]
      if ba
        ba.update_attribute(:total_count, params["book#{i+1}".to_sym])
      else
        BookSetting.create(:book_code => Constant::All_BOOKS[i][0], :total_count => params["book#{i+1}".to_sym], :created_at => Date.today)
      end
    end
    flash[:notice] = "创建成功"
    redirect_to admin_book_activities_url
  end

  def lottery
    ls = LotterySetting.find_by_active_date Date.today + 1
    if ls.nil?
    LotterySetting.create(:s_count => params[:s_count],:b_count => params[:b_count],
      :e_count => params[:e_count],:pv_count => params[:pv_count],:active_date => Date.today + 1)
    else
      ls.update_attributes(:s_count => params[:s_count],:b_count => params[:b_count],
      :e_count => params[:e_count],:pv_count => params[:pv_count])
    end
    flash[:notice] = "设置成功"
    redirect_to admin_book_activities_url
  end

end
