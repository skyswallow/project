# 用户登录验证模块
module Authenticated

  protected
  def login_required
    access_denied if !(cookies[:space_id] and cookies[:passport])
  end

  # 当space的验证信息没有通过时的操作
  def access_denied
    respond_to do |format|
      format.html do
        flash[:warn] = "请您先登录，才能继续操作"
        unless params[:to]
          store_location
          redirect_to "/community/sessions/new"
        else
          redirect_to "/community/sessions/new"
        end
      end
      format.any(:json, :xml) do
        request_http_basic_authentication 'Web Password'
      end
    end
  end

  # 记住上一个URL地址
  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end


  # 用户是否登录
  def logged_in?
    !!current_login_space
  end

  # 取当前登录用户
  def current_login_space
    return @current_space if @current_space
    @current_space = Space.find_by_id(cookies[:space_id])
    @current_space
  end

  # 必须登录的过虑器
  def is_logged
    redirect_to "/" if !cookies[:passport]
  end

  def is_admin
    if logged_in?
      if Constant::HOME_ADMINS.include?(cookies[:passport])
      else
        redirect_to "/"
      end
    else
      redirect_to  "/"
    end
  end

  def self.included(base)
    base.send :helper_method, :current_login_space, :logged_in?, :authorized? if base.respond_to? :helper_method
  end

end
