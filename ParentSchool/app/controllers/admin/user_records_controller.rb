class Admin::UserRecordsController < Admin::BaseController
  
  def index
    @user_records = PageRecord.user_records(params[:target_cellphone])       
    session[:action_type] = params[:action_type]
    @user_actions = ActionRecord.user_actions(params[:sort], params[:action_type], @user_records[0].cellphone).paginate :page => params[:page], :per_page => 30
  end

  def create
    send_file ActionRecord.to_user_actions_xls(params[:sort], params[:cell_phone], params[:area_name], params[:s_type], params[:s_group], params[:s_name], params[:class_name], session[:action_type])
  end
end
