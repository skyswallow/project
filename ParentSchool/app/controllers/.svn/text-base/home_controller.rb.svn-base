class HomeController < ApplicationController
  layout "default"

  def index
    flash.now[:warn] = "您在30分钟内没有操作，请重新登录" if params[:login_type] and params[:login_type] == "1"
    flash.now[:warn] = "您的帐号已在其他地方登录！" if params[:login_type] and params[:login_type] == "2"
    session[:proof_code] = proof_code(4) if session[:proof_code].nil?
    @index_hash = Hash.new
    @settings = IndexSetting.all
    @settings.each do |setting|
      @index_hash[setting.code] = setting.online_file_path if setting.online_file_path
    end
    space = Space.find_by_id(cookies[:space_id]) if cookies[:space_id]
    @users = User.find_all_by_person_id_and_user_type(space.user_id, User::USER_TYPE_TEACHER) if space
  end

  def get_proof_code
    session[:proof_code] = proof_code(4)
    render :inline => session[:proof_code]
  end

  def create
    flag = false
    if params[:proof_code] != session[:proof_code].to_s
      flash[:warn] = "您输入的校验码不正确，请重新输入！"
      redirect_to "/"
    else
      if Space.find_by_passport_and_password(params[:passport], params[:password])
        space = Space.find_by_passport_and_password(params[:passport], params[:password])
      else
        user = User.find_by_username_and_password(params[:passport], params[:password])
        if user
          flag = true
          if Space.find_by_user_id(user.person_id)
            space = Space.find_by_user_id(user.person_id)
          end
        end
      end
      if space and (space.is_active == true) and (space.status == 1)
        online_user = OnlineUser.find_by_space_id(space.id)
        if online_user and online_user.client_ip != request.remote_ip and online_user.status.to_i == 0
          flash[:warn] = "用户#{space.nickname}已经处于在线状态，无法同时登录！"
          redirect_to "/"
        else
          expire_fragment('index_page')
          Space.transaction do
            cookies[:passport] = space.passport
            cookies[:space_id] = space.id.to_s
          end
          redirect_to "#{CONFIG[:xuexi6_url]}/community/sessions/set_cookies?id=#{space.id.to_s}"
        end
      elsif space and space.is_active == false
        flash[:warn] = "您的帐户未激活！"
        redirect_to "/"
      elsif space and space.status == 0
        flash[:warn] = "您的帐户已被锁定！"
        redirect_to "/"
      elsif !space
        if flag
          flash[:warn] = "您输入的用户名或密码不正确,请联系客服！"
        else
          flash[:warn] = "您输入的用户名或密码不正确！"
        end
        redirect_to "/"
      end
    end
  end

  def logout
    if cookies[:space_id]
      space = Space.find_by_id(cookies[:space_id])
      space.online_status = false
      space.save
      OnlineUser.find_by_space_id(space.id).update_attribute(:status, 1) if OnlineUser.find_by_space_id(space.id)
      expire_fragment('index_page')
      cookies.delete :passport
      cookies.delete :space_id
      cookies.delete(:space_id, :domain => "ntjxt.com")
      cookies.delete(:passport, :domain => "ntjxt.com")
      cookies.delete(:nickname, :domain => "ntjxt.com")
      session.delete
    end
    redirect_to "/"
  end
end
